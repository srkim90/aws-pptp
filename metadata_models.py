import base64
import os
from datetime import datetime
from marshmallow import fields
from dataclasses import dataclass, field
from dataclasses_json import dataclass_json, config


@dataclass_json
@dataclass
class InstanceMetadata:
    instance_create_at: datetime = field(
        metadata=config(
            encoder=datetime.isoformat,
            decoder=datetime.fromisoformat,
            mm_field=fields.DateTime(format='iso')
        ))
    instance_name: str
    dns_id: str
    dns_pw: str
    domain_name: str

    @staticmethod
    def get_metadata_path():
        save_path = os.path.expanduser("~")
        save_path = os.path.join(save_path, "config")
        if os.path.exists(save_path) is False:
            os.makedirs(save_path)
        return os.path.join(save_path, "pptp.dat")


def load_metadata() -> InstanceMetadata:
    file_name = InstanceMetadata.get_metadata_path()
    with open(file_name, "rb") as fd:
        b64data: str = base64.b64decode(fd.read()).decode("utf-8")
        return InstanceMetadata.from_json(b64data)


def save_metadata_as_json(metadata: InstanceMetadata) -> str:
    file_name = InstanceMetadata.get_metadata_path()
    json_data = InstanceMetadata.to_json(metadata, indent=4, ensure_ascii=False).encode("utf-8")
    b64_data = base64.b64encode(json_data).decode("utf-8")
    with open(file_name, "w") as fd:
        fd.write(b64_data)
    return file_name
