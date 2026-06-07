from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware # <-- 1. Import the CORS tool
from pydantic import BaseModel
from nlp_engine.analyzer import extract_policy_keywords

app = FastAPI()

# 2. Add the VIP Pass (CORS Middleware)
# This tells Python to accept POST requests from your Flutter frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Allows any frontend to connect
    allow_credentials=True,
    allow_methods=["*"], # Allows POST requests
    allow_headers=["*"], # Allows JSON headers
)

class PolicyRequest(BaseModel):
    text: str

@app.get("/")
def read_root():
    return {"status": "success", "message": "The AI Backend is running!"}

@app.post("/analyze")
def analyze_text(request: PolicyRequest):
    result = extract_policy_keywords(request.text)
    return result