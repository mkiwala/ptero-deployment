import unittest
from ptero_deployment.config import PTeroDeploymentConfig


class TestConfigSet(unittest.TestCase):
    def setUp(self):
        self.config = PTeroDeploymentConfig(
            '/Users/mkiwala/Projects/ptero/deployment/'
            'tests/deployment-config.json')

    def test_get_app_environment(self):
        pass
        self.assertEqual(
            self.config.get_app_config('lsf-staging'),
            {
                'PTERO_ALLOW_JANITORS': '1',
                'PTERO_LOG_FORMAT_JSON': '1',
                'PTERO_LSF_CELERYD_PREFETCH_MULTIPLIER': '1',
                'PTERO_LSF_CELERY_ACCEPT_CONTENT': 'json',
                'PTERO_LSF_CELERY_ACKS_LATE': '1',
                'PTERO_LSF_CELERY_BROKER_URL':
                    'amqp://guest:guest@10.0.48.167/lsf',
                'PTERO_LSF_CELERY_RESULT_BACKEND': 'redis://10.0.48.167:6379',
                'PTERO_LSF_CELERY_RESULT_SERIALIZER': 'json',
                'PTERO_LSF_CELERY_TASK_SERIALIZER': 'json',
                'PTERO_LSF_CELERY_TRACK_STARTED': '1',
                'PTERO_LSF_DB_STRING':
                    'postgres://ptero:ptero-staging@10.0.48.167/ptero_lsf',
                'PTERO_LSF_LOG_LEVEL': 'DEBUG',
                'PTERO_LSF_NON_WORKER': '1',
                'PTERO_LSF_PORT': '5000'
            })

if __name__ == '__main__':
    unittest.main()
