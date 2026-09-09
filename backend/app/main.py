from fastapi import FastAPI
app = FastAPI(title="Rekindle API")

@app.get("/health")
def health_check():
    return {"status": "ok"}
