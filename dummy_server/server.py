import asyncio
import json
import websockets
from enum import Enum
import socket
import threading
import random
from zeroconf.asyncio import AsyncZeroconf
from zeroconf import ServiceInfo

def get_local_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
        return local_ip
    except Exception:
        return "127.0.0.1"  # Fallback to localhost if unable to determine IP

class State(Enum):
    WORKING = "WORKING"
    IDLE = "IDLE"
    POWERLOSS = "POWERLOSS"
    DONE = "DONE"
    HALT = "HALT"

class DipMachine:
    def __init__(self):
        self.state = State.IDLE
        self.clients = set()
        self.lock = asyncio.Lock()
        self.dip_task = None
        
        self.attempts = random.randint(1,5)
        self.i = 0

        self.msg = {
            "state": "IDLE",
            "timeLeft": 0,
            "onBeaker": 1,
            "onCycle": 1,
            "error": "Check Sensors: 1, 2, 3",
            "currentTemp": [1] * 6,
            "setCycles": 1,
            "activeBeakers": 1,
            "setDipDuration": [1] * 6,
            "setDipRPM": [1] * 6,
            "setDipTemperature": [5] * 6
        }

    async def broadcast(self):
        if self.clients:
            message = json.dumps(self.msg)
            await asyncio.gather(*[client.send(message) for client in self.clients])

    async def set_state(self, new_state):
        async with self.lock:
            self.state = new_state
            self.msg["state"] = self.state.value
            print(f"\n[set_state] Data broadcasted: {self.msg}")
            await self.broadcast()
        print(f"State changed to: {self.state.value}")

    async def handle_websocket(self, websocket):
        try:
            self.clients.add(websocket)
            print(f"[handle_websocket]Data broadcasted: {self.msg}")
            await self.broadcast()
            print(f"New client connected. Total clients: {len(self.clients)}")
            
            async for message in websocket:
                await self.process_message(message)
        except websockets.exceptions.ConnectionClosed:
            print("Client connection closed unexpectedly")
        finally:
            self.clients.remove(websocket)
            print(f"Client disconnected. Total clients: {len(self.clients)}")

    async def recheck(self):
        if self.i <= self.attempts:
            print(f"Try Again: {self.i}/{self.attempts}")
            self.msg["error"] = "Sensor thik se laga BKL!"
            self.i += 1
            print(f"\n[recheck] Data broadcasted: {self.msg}")
            await asyncio.sleep(1)
            await self.broadcast()
        else:
            await self.set_state(State.IDLE)

    async def process_message(self, message):
        try:
            data = json.loads(message)
            print(f"Received from client: {data}")
            command = data.get("state")
            
            if command == "start":
                await self.start_dip_task(data)
            elif command == "abort":
                await self.abort_dip_task()
            elif command == "recover":
                await self.start_dip_task(data)
            elif command == "new":
                await self.set_state(State.IDLE)
            elif command == "recheck" and self.state == State.HALT:
                await self.recheck()
            else:
                print(f"Unknown command: {command}")
        except json.JSONDecodeError:
            print(f"Invalid JSON received: {message}")
        except Exception as e:
            print(f"Error processing message: {e}")

    async def start_dip_task(self, data):
        if self.dip_task:
            self.dip_task.cancel()
        self.set_data(data)
        await self.set_state(State.WORKING)
        self.dip_task = asyncio.create_task(self.dip_machine_operation(int(data["setCycles"]), data["activeBeakers"]))

    async def abort_dip_task(self):
        if self.dip_task:
            self.dip_task.cancel()
        await self.set_state(State.IDLE)

    def set_data(self, data):
        try:
            self.msg["timeLeft"] = (data["activeBeakers"] * 3) * data["setCycles"]  # Assuming 3 seconds per beaker
            self.msg["activeBeakers"] = data["activeBeakers"]
            self.msg["setCycles"] = data["setCycles"]
            self.msg["setDipDuration"] = data["setDipDuration"][:data["activeBeakers"]]
            self.msg["currentTemp"] = data["setDipTemperature"][:data["activeBeakers"]]
            self.msg["setDipTemperature"] = data["setDipTemperature"][:data["activeBeakers"]]
            self.msg["setDipRPM"] = data["setDipRPM"][:data["activeBeakers"]]
        except:
            print('maybe recovering')

    async def dip_machine_operation(self, cycles, beakers):
        try:
            print("Starting dip machine operation")
            for cycle in range(1, cycles + 1):
                if self.state != State.WORKING:
                    break
                print(f"Cycle {cycle}/{cycles}")
                self.msg["onCycle"] = cycle
                for i in range(1, beakers + 1):
                    if self.state != State.WORKING:
                        break
                    self.msg["currentTemp"] = [round(random.uniform(25.00, 100.00), 2) for _ in range(beakers)]
                    await asyncio.sleep(3)  # Simulating operation time
                    self.msg["onBeaker"] = i-1
                    if self.msg["timeLeft"] > 0:
                        self.msg["timeLeft"] -= 3
                    print(f"\n[dip_machine_operation] Data broadcasted: {self.msg}")
                    await self.broadcast()
                    print(f"onBeaker: {self.msg['onBeaker']}, currentTemp: {self.msg['currentTemp']}, timeLeft: {self.msg['timeLeft']}")
            await self.auto_idle()
        except asyncio.CancelledError:
            print("Dip machine operation cancelled")
        except Exception as e:
            print(f"Error in dip machine operation: {e}")

    async def auto_idle(self):
        if self.state == State.WORKING:
            await asyncio.sleep(3)
            await self.set_state(State.DONE)
            await asyncio.sleep(5)
            await self.set_state(State.IDLE)

async def change_state_input(dip_machine):
    while True:
        new_state = await asyncio.to_thread(input, "Enter new state ([1] WORKING [2] IDLE [3] POWERLOSS [4] DONE [5] HALT): ")
        try:
            new_state = int(new_state)
            states = [State.WORKING, State.IDLE, State.POWERLOSS, State.DONE, State.HALT]
            if 1 <= new_state <= 5:
                await dip_machine.set_state(states[new_state - 1])
            else:
                print("Invalid state number. Please try again.")
        except ValueError:
            print("Invalid input. Please enter a number.")

async def main():
    dip_machine = DipMachine()
    local_ip = get_local_ip()
    port = 8000

    # Set up AsyncZeroconf
    azc = AsyncZeroconf()
    service_info = ServiceInfo(
        "_http._tcp.local.",
        "dipmachine._http._tcp.local.",
        addresses=[socket.inet_aton(local_ip)],
        port=port,
        properties={'path': '/ws'}
    )
    await azc.async_register_service(service_info)

    server = await websockets.serve(
        dip_machine.handle_websocket,
        "0.0.0.0",
        port,
        process_request=lambda path, _: None if path == '/ws' else (404, [], b'404 Not Found')
    )
    print(f"WebSocket server started on ws://{local_ip}:{port}/ws")
    print(f"mDNS service registered as 'dipmachine.local'")
    
    input_task = asyncio.create_task(change_state_input(dip_machine))
    
    try:
        await asyncio.gather(server.wait_closed(), input_task)
    finally:
        await azc.async_unregister_service(service_info)
        await azc.async_close()

if __name__ == "__main__":
 
