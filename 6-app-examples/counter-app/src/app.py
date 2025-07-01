from flask import Flask, Response, render_template_string, request, redirect, url_for
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

# Define a Prometheus counter
button_clicks = Counter("button_clicks_total", "Total number of button clicks")

# Image URL
IMAGE_URL = "https://pbs.twimg.com/media/GLvBnqSXQAAPNry?format=jpg&name=360x360"

# HTML template
HTML = f"""
<!DOCTYPE html>
<html>
<head>
    <title>Image Button App</title>
</head>
<body style="text-align: center; padding-top: 50px;">
    <h1>Click the Button!</h1>
    <img src="{IMAGE_URL}" alt="funny pic" style="width: 300px; border-radius: 8px;" /><br><br>
    <form action="/click" method="post">
        <button type="submit" style="padding: 10px 20px; font-size: 16px;">Click Me!</button>
    </form>
</body>
</html>
"""

@app.route("/", methods=["GET"])
def index():
    return render_template_string(HTML)

@app.route("/click", methods=["POST"])
def click():
    button_clicks.inc()
    return redirect(url_for("index"))

@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
