from flask import Flask, request, jsonify
from flask_cors import CORS
import fitz  # PyMuPDF
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

app = Flask(__name__)
CORS(app)  # Allow requests from any origin

# Function to extract text from PDF resume
def extract_text_from_pdf(pdf_file):
    document = fitz.open(pdf_file)  # Open the PDF file
    text = ""
    for page in document:
        text += page.get_text()  # Extract text from each page
    return text

# Function to calculate match score
def calculate_match_score(resume_text, job_description):
    # Combine resume and job description to compare using TF-IDF
    corpus = [resume_text, job_description]
    
    vectorizer = TfidfVectorizer(stop_words='english')
    tfidf_matrix = vectorizer.fit_transform(corpus)
    similarity_matrix = cosine_similarity(tfidf_matrix[0:1], tfidf_matrix[1:2])
    
    # Return similarity score as percentage
    return similarity_matrix[0][0] * 100

@app.route('/match', methods=['POST'])
def match():
    print("Received request")
    resume_file = request.files['resume']
    job_description = request.form['jd']
    
    print("Saving file...")
    resume_file.save("temp_resume.pdf")

    try:
        print("Extracting text...")
        resume_text = extract_text_from_pdf("temp_resume.pdf")
    except Exception as e:
        print(f"Error in PDF processing: {e}")
        return jsonify({"score": 0, "feedback": "Failed to read PDF"}), 500

    try:
        print("Calculating score...")
        score = calculate_match_score(resume_text, job_description)
    except Exception as e:
        print(f"Error in matching logic: {e}")
        return jsonify({"score": 0, "feedback": "Matching failed"}), 500

    feedback = "Great match!" if score >= 80 else "Consider improving your resume or skills."
    print(f"Returning result: {score}%")
    
    return jsonify({"score": round(score, 2), "feedback": feedback})

# Gunicorn will use this to run the app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
