from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"Project": "Time For Public", "Status": "Backend Running"}

@app.get("/officer/{id}")
def get_officer_status(id: int):
    # This is a dummy response for now
    return {"officer_id": id, "status": "Available", "location": "Taluka Office"} 