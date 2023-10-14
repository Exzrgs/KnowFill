from google.cloud import vision
import json
import requests
import base64
import environ
env = environ.Env()
env.read_env('.env')
ENDPOINT_URL = env('ENDPOINT_URL')
API_KEY = env('API_KEY')

#with open(r'E:\KnowFill\backend\api\スクリーンショット 2023-07-02 160155.png', 'rb') as image_file:
#    content = base64.b64encode(image_file.read())
#    content =  content.decode('utf-8')

def ocr(content):
    image_requests = {
            'image': {'content': content},
            'features': [{
                    'type': 'DOCUMENT_TEXT_DETECTION',
                    'maxResults': 3
                    }]
            }

    response = requests.post(ENDPOINT_URL,
                            data=json.dumps({"requests": image_requests}),
                            params={'key': API_KEY},
                            headers={'Content-Type': 'application/json'})

    # print(response.text)
    response = json.loads(response.text)
    response_disc = response['responses'][0]['textAnnotations'][0]['description']
    # print(response_disc)
    return response_disc.replace('\n', '')