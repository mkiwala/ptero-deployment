from fabric.api import *


@task
def fast(name, tag):
    '''
    Runs integration tests to verify a deployment.
    '''
    print 'running fast tests from', tag, 'on', name


@task
def slow(name, tag):
    '''
    Runs intentionally long-running tests to verify the an update.
    '''
    print 'running slow tests from', tag, 'on', name
