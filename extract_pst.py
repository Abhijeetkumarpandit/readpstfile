from flask import Flask, jsonify, request
import pypff
import os

app = Flask(__name__)

# Function to extract emails from a PST file
def extract_emails(pst_path):
    emails = []
    pst = pypff.file()
    pst.open(pst_path)

    for folder in pst.get_root_folder().sub_folders:
        for message in folder.sub_messages:
            email_data = {
                "subject": message.subject,
                "sender": message.sender_name,
                "to": message.display_to,
                "cc": message.display_cc,
                "body": message.plain_text_body or message.html_body
            }
            emails.append(email_data)

    return emails

# Flask route to process PST file
@app.route('/upload', methods=['POST'])
def upload_pst():
    if 'file' not in request.files:
        return jsonify({"error": "No file provided"}), 400
    
    file = request.files['file']
    filepath = os.path.join("/tmp", file.filename)
    file.save(filepath)

    try:
        emails = extract_emails(filepath)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    os.remove(filepath)  # Clean up the file after processing
    return jsonify(emails)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
