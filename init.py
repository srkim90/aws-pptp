import os
import sys

from metadata import PPTPMetadata


def main():
    try:
        instance_name: str = sys.argv[1]
        dns_id: str = sys.argv[2]
        dns_pw: str = sys.argv[3]
        domain_name: str = sys.argv[4]
    except Exception:
        print("python3 [instance_name] [dns_id] [dns_pw] [domain_name]")
        return
    e = PPTPMetadata()
    e.save(instance_name, dns_id, dns_pw, domain_name)
    os.system("/bin/bash init.sh")

if __name__ == '__main__':
    main()
