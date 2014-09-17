from ptero_auth.api.application import create_app
from ptero_auth.settings import get_from_env

app = create_app(get_from_env())
