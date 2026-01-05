from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World - Deployed using Terraform, Docker, Kubernetes, and CI/CD"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
