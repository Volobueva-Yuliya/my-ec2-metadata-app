from flask import Flask, jsonify
import json
import urllib.request
import urllib.error

app = Flask(__name__)

TOKEN_URL = "http://169.254.169.254/latest/api/token"
AZ_URL = "http://169.254.169.254/latest/meta-data/placement/availability-zone"
IID_URL = "http://169.254.169.254/latest/dynamic/instance-identity/document"


def get_imds_token() -> str:
    req = urllib.request.Request(TOKEN_URL, method="PUT")
    req.add_header("X-aws-ec2-metadata-token-ttl-seconds", "21600")
    with urllib.request.urlopen(req, timeout=2) as resp:
        return resp.read().decode("utf-8")


def get_metadata(url: str, token: str) -> str:
    req = urllib.request.Request(url)
    req.add_header("X-aws-ec2-metadata-token", token)
    with urllib.request.urlopen(req, timeout=2) as resp:
        return resp.read().decode("utf-8")


@app.route("/", methods=["GET"])
def root():
    try:
        token = get_imds_token()
        az = get_metadata(AZ_URL, token)
        identity_doc = json.loads(get_metadata(IID_URL, token))
        region = identity_doc["region"]

        return jsonify({
            "region": region,
            "availabilityZone": az
        }), 200

    except (urllib.error.URLError, urllib.error.HTTPError, KeyError, json.JSONDecodeError) as e:
        return jsonify({
            "error": "Failed to read EC2 metadata",
            "details": str(e)
        }), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)