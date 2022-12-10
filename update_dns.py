import json

import requests

from metadata_models import load_metadata

DOMAIN = "https://www.halfdomain.co.kr/"


class DnsUpdate:
    sess: requests.Session

    def __init__(self, domain_name, uid, pwd) -> None:
        super().__init__()
        self.domain_name: str = domain_name
        self.uid: str = uid
        self.pwd: str = pwd
        self.sess = requests.Session()

    @staticmethod
    def __make_url(uri: str):
        uri = uri.strip()
        if uri[0] == "/":
            uri = uri[1:]
        return DOMAIN + uri

    def __login(self):
        self.sess = requests.Session()
        self.sess.get(self.__make_url("index"))
        result = self.sess.post(self.__make_url("user/loginAct.jsp"), data={
            "rtn_uri": "/index",
            "user_id": self.uid,
            "user_pwd": self.pwd,
        })
        return

    def __get_domain_no(self) -> int:
        result = self.sess.get(self.__make_url("service/dns#address")).text
        result = result.split('hd_select_domain_layer')[1].split('</div>')[0]
        for item in result.split('input type="radio" name="domainNo"'):
            if 'value="' not in item:
                continue
            item = item.split('</tr>')[0]
            domain_name = item.split('<td>')[1].split("</td>")[0]
            domain_no = int(item.split('value="')[1].split('"')[0])

            if domain_name == self.domain_name:
                return domain_no
        raise NotImplementedError

    def __get_addrs_no(self, domain_no: int, subdomain: str) -> int:
        result = self.sess.post(self.__make_url("/service/dns/get"), data={
            "type": "address",
            "domain_no": domain_no
        })
        '''
            {
            "status":"200",
            "message":"SUCCESS",
            "data":{
                "address":[
                    {
                    "address_no":10319,
                    "domain_no":48127,
                    "subdomain":"",
                    "address_type":"\u0000",
                    "user_no":0,
                    "del_yn":"\u0000",
                    "regist_dt":null,
                    "update_dt":null,
                    "ip":"59.11.67.116"
                    },
                    {
                    "address_no":10875,
                    "domain_no":48127,
                    "subdomain":"mail",
                    "address_type":"\u0000",
                    "user_no":0,
                    "del_yn":"\u0000",
                    "regist_dt":null,
                    "update_dt":null,
                    "ip":"59.11.67.116"
        '''
        for item in json.loads(result.text)["data"]["address"]:
            __subdomain = item["subdomain"]
            if __subdomain == subdomain:
                return item["address_no"]
        raise NotImplementedError

    def update(self, subdomain: str, ipaddr: str) -> bool:
        self.__login()
        try:
            domain_no = self.__get_domain_no()
            address_no = self.__get_addrs_no(domain_no, subdomain)
        except NotImplementedError as e:
            return False
        result = self.sess.post(self.__make_url("service/dns/modify"), data={
            "type": "address",
            "domain_no": domain_no,
            "address_no": address_no,
            "subdomain": subdomain,
            "IP": ipaddr
        })
        result_logout = self.sess.get(self.__make_url("user/logout.jsp"))
        return True


def main():
    pptp = load_metadata()
    uid = pptp.dns_id
    passwd = pptp.dns_pw
    domain = pptp.domain_name
    e = DnsUpdate(domain, uid, passwd)
    e.update("vpn-kr1", "222.12.232.2")


if __name__ == '__main__':
    main()
