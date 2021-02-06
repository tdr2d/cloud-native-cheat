import email, smtplib, ssl
from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import os
import argparse


"""
usage: send_mail.py [-h] [-from FROM_EMAIL] -t TO -s SUBJECT --body BODY
                    [-f FILES]

optional arguments:
  -h, --help            show this help message and exit
  -from FROM_EMAIL, --from_email FROM_EMAIL
                        From email
  -t TO, --to TO        Destination emails
  -s SUBJECT, --subject SUBJECT
                        Subject of the email
  --body BODY           Text message
  -f FILES, --files FILES
                        Attachement files
"""

SMTP_SERVER = os.getenv('SMTP_SERVER', 'smtp-server.gmail.com')
SMTP_PORT = int(os.getenv('SMTP_PORT', '25'))
DEFAULT_FROM =  os.getenv('DEFAULT_FROM', 'support@my-corp.ltd')

def attach_file(message, filename='document.txt'):
    with open(filename, "rb") as attachment:
        part = MIMEBase("application", "octet-stream")
        part.set_payload(attachment.read())
        encoders.encode_base64(part)
        part.add_header('Content-Disposition','attachment; filename="%s"' % os.path.basename(filepath))
        message.attach(part)

def send_text_mail(from_email, to_emails, subject, body, files):
    message = MIMEMultipart()
    message["From"] = from_email
    message["To"] = ', '.join(to_emails)
    message["Subject"] = subject
    message.attach(MIMEText(body, "plain"))
    for f in files:
        attach_file(message, f)

    server = smtplib.SMTP()
    server.connect(SMTP_SERVER, port=SMTP_PORT)
    server.helo()
    server.sendmail(from_email, to_emails, message.as_string())
    server.quit()

def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("-from", '--from_email', type=str, help="From email", default=DEFAULT_FROM)
    parser.add_argument('-t', "--to", action='append', help="Destination emails", required=True)
    parser.add_argument('-s', "--subject", type=str, help="Subject of the email", required=True)
    parser.add_argument("--body", type=str, help="Text message", required=True)
    parser.add_argument("-f", '--files', action='append', help="Attachement files", default=[])
    return parser.parse_args()
    
if __name__ == '__main__':
    args = parse_arguments()
    send_text_mail(args.from_email, args.to, args.subject, args.body, args.files)
