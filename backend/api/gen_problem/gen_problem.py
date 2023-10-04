# -*- coding:utf-8 -*-

import os
import urllib.request
import json
import configparser
import codecs
import pprint
import csv
from japanese_lemmas_python_set import japanese_lemmas_set
import re

# COTOHA API操作用クラス
class CotohaApi:
    # 初期化
    def __init__(self, client_id, client_secret, developer_api_base_url, access_token_publish_url):
        self.client_id = client_id
        self.client_secret = client_secret
        self.developer_api_base_url = developer_api_base_url
        self.access_token_publish_url = access_token_publish_url
        self.getAccessToken()

    # アクセストークン取得
    def getAccessToken(self):
        # アクセストークン取得URL指定
        url = self.access_token_publish_url

        # ヘッダ指定
        headers={
            "Content-Type": "application/json;charset=UTF-8"
        }

        # リクエストボディ指定
        data = {
            "grantType": "client_credentials",
            "clientId": self.client_id,
            "clientSecret": self.client_secret
        }
        # リクエストボディ指定をJSONにエンコード
        data = json.dumps(data).encode()

        # リクエスト生成
        req = urllib.request.Request(url, data, headers)

        # リクエストを送信し、レスポンスを受信
        res = urllib.request.urlopen(req)

        # レスポンスボディ取得
        res_body = res.read()

        # レスポンスボディをJSONからデコード
        res_body = json.loads(res_body)

        # レスポンスボディからアクセストークンを取得
        self.access_token = res_body["access_token"]


    # 構文解析API
    def parse(self, sentence):
        # 構文解析API URL指定
        url = self.developer_api_base_url + "v1/parse"
        # ヘッダ指定
        headers={
            "Authorization": "Bearer " + self.access_token,
            "Content-Type": "application/json;charset=UTF-8",
        }
        # リクエストボディ指定
        data = {
            "sentence": sentence
        }
        # リクエストボディ指定をJSONにエンコード
        data = json.dumps(data).encode()
        # リクエスト生成
        req = urllib.request.Request(url, data, headers)
        # リクエストを送信し、レスポンスを受信
        try:
            res = urllib.request.urlopen(req)
        # リクエストでエラーが発生した場合の処理
        except urllib.request.HTTPError as e:
            # ステータスコードが401 Unauthorizedならアクセストークンを取得し直して再リクエスト
            if e.code == 401:
                print ("get access token")
                self.access_token = self.getAccessToken(self.client_id, self.client_secret)
                headers["Authorization"] = "Bearer " + self.access_token
                req = urllib.request.Request(url, data, headers)
                res = urllib.request.urlopen(req)
            # 401以外のエラーなら原因を表示
            else:
                print ("<Error> " + e.reason)

        # レスポンスボディ取得
        res_body = res.read()
        # レスポンスボディをJSONからデコード
        res_body = json.loads(res_body)
        # レスポンスボディから解析結果を取得
        return res_body


    # 固有表現抽出API
    def ne(self, sentence):
        # 固有表現抽出API URL指定
        url = self.developer_api_base_url + "v1/ne"
        # ヘッダ指定
        headers={
            "Authorization": "Bearer " + self.access_token,
            "Content-Type": "application/json;charset=UTF-8",
        }
        # リクエストボディ指定
        data = {
            "sentence": sentence
        }
        # リクエストボディ指定をJSONにエンコード
        data = json.dumps(data).encode()
        # リクエスト生成
        req = urllib.request.Request(url, data, headers)
        # リクエストを送信し、レスポンスを受信
        try:
            res = urllib.request.urlopen(req)
        # リクエストでエラーが発生した場合の処理
        except urllib.request.HTTPError as e:
            print(e)
            # ステータスコードが401 Unauthorizedならアクセストークンを取得し直して再リクエスト
            if e.code == 401:
                print ("get access token")
                self.access_token = self.getAccessToken(self.client_id, self.client_secret)
                headers["Authorization"] = "Bearer " + self.access_token
                req = urllib.request.Request(url, data, headers)
                res = urllib.request.urlopen(req)
            # 401以外のエラーなら原因を表示
            else:
                print ("<Error> " + e.reason)

        # レスポンスボディ取得
        res_body = res.read()
        # レスポンスボディをJSONからデコード
        res_body = json.loads(res_body)
        # レスポンスボディから解析結果を取得
        return res_body


    # 照応解析API
    def coreference(self, document):
        # 照応解析API 取得URL指定
        url = self.developer_api_base_url + "beta/coreference"
        # ヘッダ指定
        headers={
            "Authorization": "Bearer " + self.access_token,
            "Content-Type": "application/json;charset=UTF-8",
        }
        # リクエストボディ指定
        data = {
            "document": document
        }
        # リクエストボディ指定をJSONにエンコード
        data = json.dumps(data).encode()
        # リクエスト生成
        req = urllib.request.Request(url, data, headers)
        # リクエストを送信し、レスポンスを受信
        try:
            res = urllib.request.urlopen(req)
        # リクエストでエラーが発生した場合の処理
        except urllib.request.HTTPError as e:
            # ステータスコードが401 Unauthorizedならアクセストークンを取得し直して再リクエスト
            if e.code == 401:
                print ("get access token")
                self.access_token = self.getAccessToken(self.client_id, self.client_secret)
                headers["Authorization"] = "Bearer " + self.access_token
                req = urllib.request.Request(url, data, headers)
                res = urllib.request.urlopen(req)
            # 401以外のエラーなら原因を表示
            else:
                print ("<Error> " + e.reason)

        # レスポンスボディ取得
        res_body = res.read()
        # レスポンスボディをJSONからデコード
        res_body = json.loads(res_body)
        # レスポンスボディから解析結果を取得
        return res_body


    # キーワード抽出API
    def keyword(self, document):
        # キーワード抽出API URL指定
        url = self.developer_api_base_url + "v1/keyword"
        # ヘッダ指定
        headers={
            "Authorization": "Bearer " + self.access_token,
            "Content-Type": "application/json;charset=UTF-8",
        }
        # リクエストボディ指定
        data = {
            "document": document
        }
        # リクエストボディ指定をJSONにエンコード
        data = json.dumps(data).encode()
        # リクエスト生成
        req = urllib.request.Request(url, data, headers)
        # リクエストを送信し、レスポンスを受信
        try:
            res = urllib.request.urlopen(req)
        # リクエストでエラーが発生した場合の処理
        except urllib.request.HTTPError as e:
            # ステータスコードが401 Unauthorizedならアクセストークンを取得し直して再リクエスト
            if e.code == 401:
                print ("get access token")
                self.access_token = self.getAccessToken(self.client_id, self.client_secret)
                headers["Authorization"] = "Bearer " + self.access_token
                req = urllib.request.Request(url, data, headers)
                res = urllib.request.urlopen(req)
            # 401以外のエラーなら原因を表示
            else:
                print ("<Error> " + e.reason)

        # レスポンスボディ取得
        res_body = res.read()
        # レスポンスボディをJSONからデコード
        res_body = json.loads(res_body)
        # レスポンスボディから解析結果を取得
        return res_body


    # 類似度算出API
    def similarity(self, s1, s2):
        # 類似度算出API URL指定
        url = self.developer_api_base_url + "v1/similarity"
        # ヘッダ指定
        headers={
            "Authorization": "Bearer " + self.access_token,
            "Content-Type": "application/json;charset=UTF-8",
        }
        # リクエストボディ指定
        data = {
            "s1": s1,
            "s2": s2
        }
        # リクエストボディ指定をJSONにエンコード
        data = json.dumps(data).encode()
        # リクエスト生成
        req = urllib.request.Request(url, data, headers)
        # リクエストを送信し、レスポンスを受信
        try:
            res = urllib.request.urlopen(req)
        # リクエストでエラーが発生した場合の処理
        except urllib.request.HTTPError as e:
            # ステータスコードが401 Unauthorizedならアクセストークンを取得し直して再リクエスト
            if e.code == 401:
                print ("get access token")
                self.access_token = self.getAccessToken(self.client_id, self.client_secret)
                headers["Authorization"] = "Bearer " + self.access_token
                req = urllib.request.Request(url, data, headers)
                res = urllib.request.urlopen(req)
            # 401以外のエラーなら原因を表示
            else:
                print ("<Error> " + e.reason)

        # レスポンスボディ取得
        res_body = res.read()
        # レスポンスボディをJSONからデコード
        res_body = json.loads(res_body)
        # レスポンスボディから解析結果を取得
        return res_body


    # 文タイプ判定API
    def sentenceType(self, sentence):
        # 文タイプ判定API URL指定
        url = self.developer_api_base_url + "v1/sentence_type"
        # ヘッダ指定
        headers={
            "Authorization": "Bearer " + self.access_token,
            "Content-Type": "application/json;charset=UTF-8",
        }
        # リクエストボディ指定
        data = {
            "sentence": sentence
        }
        # リクエストボディ指定をJSONにエンコード
        data = json.dumps(data).encode()
        # リクエスト生成
        req = urllib.request.Request(url, data, headers)
        # リクエストを送信し、レスポンスを受信
        try:
            res = urllib.request.urlopen(req)
        # リクエストでエラーが発生した場合の処理
        except urllib.request.HTTPError as e:
            # ステータスコードが401 Unauthorizedならアクセストークンを取得し直して再リクエスト
            if e.code == 401:
                print ("get access token")
                self.access_token = self.getAccessToken(self.client_id, self.client_secret)
                headers["Authorization"] = "Bearer " + self.access_token
                req = urllib.request.Request(url, data, headers)
                res = urllib.request.urlopen(req)
            # 401以外のエラーなら原因を表示
            else:
                print ("<Error> " + e.reason)

        # レスポンスボディ取得
        res_body = res.read()
        # レスポンスボディをJSONからデコード
        res_body = json.loads(res_body)
        # レスポンスボディから解析結果を取得
        return res_body


    # ユーザ属性推定API
    def userAttribute(self, document):
        # ユーザ属性推定API URL指定
        url = self.developer_api_base_url + "beta/user_attribute"
        # ヘッダ指定
        headers={
            "Authorization": "Bearer " + self.access_token,
            "Content-Type": "application/json;charset=UTF-8",
        }
        # リクエストボディ指定
        data = {
            "document": document
        }
        # リクエストボディ指定をJSONにエンコード
        data = json.dumps(data).encode()
        # リクエスト生成
        req = urllib.request.Request(url, data, headers)
        # リクエストを送信し、レスポンスを受信
        try:
            res = urllib.request.urlopen(req)
        # リクエストでエラーが発生した場合の処理
        except urllib.request.HTTPError as e:
            # ステータスコードが401 Unauthorizedならアクセストークンを取得し直して再リクエスト
            if e.code == 401:
                print ("get access token")
                self.access_token = self.getAccessToken(self.client_id, self.client_secret)
                headers["Authorization"] = "Bearer " + self.access_token
                req = urllib.request.Request(url, data, headers)
                res = urllib.request.urlopen(req)
            # 401以外のエラーなら原因を表示
            else:
                print ("<Error> " + e.reason)

        # レスポンスボディ取得
        res_body = res.read()
        # レスポンスボディをJSONからデコード
        res_body = json.loads(res_body)
        # レスポンスボディから解析結果を取得
        return res_body


# sentence [str] 解析対象文
def gen_problem(sentence: str) -> dict:
    """
    問題生成関数
    """
    # ソースファイルの場所取得
    APP_ROOT = os.path.dirname(os.path.abspath( __file__)) + "/"

    # 設定値取得
    config = configparser.ConfigParser()
    config.read(APP_ROOT + "config.ini")
    CLIENT_ID = config.get("COTOHA API", "Developer Client id")
    CLIENT_SECRET = config.get("COTOHA API", "Developer Client secret")
    DEVELOPER_API_BASE_URL = config.get("COTOHA API", "Developer API Base URL")
    ACCESS_TOKEN_PUBLISH_URL = config.get("COTOHA API", "Access Token Publish URL")

    # COTOHA APIインスタンス生成
    cotoha_api = CotohaApi(CLIENT_ID, CLIENT_SECRET, DEVELOPER_API_BASE_URL, ACCESS_TOKEN_PUBLISH_URL)

    # 構文解析API実行
    result_ne = cotoha_api.ne(sentence)
    result_keyword = cotoha_api.keyword(sentence)
    
    #print(resutl_parse['result'])
    
    #print(result_ne)
    #print(result_keyword["status"])
    #result_parse = cotoha_api.parse(sentence)
    #pprint.pprint(result_parse["result"][0]["tokens"][0]["form"])

    # センテンスの分かち書き
    #t = Tokenizer()
    # https://mocobeta.github.io/janome/api/janome.html#janome.tokenizer.Token
    #parseed_sentence = [str(token).split()[0] for token in t.tokenize(sentence)]
    #print(parseed_sentence)

    
    
    ne_set = set()
    result_ne_result = result_ne["result"]
    ne_list = list()
    for result_ne_dict in result_ne_result:
        ne_set.add(result_ne_dict["form"])
        ne_list.append(result_ne_dict["form"])
        print(result_ne_dict["form"])
        
    
    keyword_set = set()
    result_keyword_result = result_keyword["result"]
    keyword_list = list()
    for result_keyword_dict in result_keyword_result:
        keyword_set.add(result_keyword_dict["form"])
        keyword_list.append(result_keyword_dict["form"])
        print(result_keyword_dict["form"])
    
    japanese_lemmas_set = japanese_lemmas_set()
    #japanese_lemmas_set = set()
    res = sentence
    anser = dict()
    c = 1
    for ne_word in ne_list:
        if not(ne_word in japanese_lemmas_set):
            res = res.replace(ne_word, "(　"+ str(c) +"　)")
            anser[c] = ne_word
            c += 1

    for keyword_word in keyword_list:
        if not(keyword_word in japanese_lemmas_set):
            res = re.sub(keyword_word, "(　"+ str(c) +"　)", res)
            anser[c] = keyword_word
            c += 1
    result_dict = dict()
    result_dict['mondaibun_list'] = res
    result_dict['ana'] = anser
    print(result_dict)

    return result_dict