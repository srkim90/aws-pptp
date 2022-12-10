import requests

from metadata_models import load_metadata
from update_dns import DnsUpdate


def get_public_ip():
    ipaddr = requests.get("http://checkip.amazonaws.com").text
    return ipaddr.strip().replace("\n", "")

def main():
    pptp = load_metadata()
    uid = pptp.dns_id
    passwd = pptp.dns_pw
    domain = pptp.domain_name
    e = DnsUpdate(domain, uid, passwd)
    e.update(pptp.instance_name, get_public_ip())


if __name__ == '__main__':
    main()
