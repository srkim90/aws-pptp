import datetime
import os

from metadata_models import InstanceMetadata, save_metadata_as_json


class PPTPMetadata:
    def __init__(self) -> None:
        super().__init__()

    def save(self, instance_name: str, dns_id: str, dns_pw: str, domain_name: str):
        e = InstanceMetadata(instance_create_at=datetime.datetime.now(),
                         instance_name=instance_name,
                         dns_id=dns_id,
                         dns_pw=dns_pw,
                         domain_name=domain_name)
        save_path = save_metadata_as_json(e)
        print("PPTPMetadata is saved : %s" % (save_path,))


