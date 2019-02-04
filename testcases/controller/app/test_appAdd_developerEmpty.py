#!/usr/local/bin/python3

#
# create app with developer empty and missing 
# verify 'Invalid developer name' is received
# 

import unittest
import grpc
import sys
import time
from delayedassert import expect, expect_equal, assert_expectations
import logging
import os

from MexController import mex_controller

controller_address = os.getenv('AUTOMATION_CONTROLLER_ADDRESS', '127.0.0.1:55001')

access_ports = 'tcp:1'

mex_root_cert = 'mex-ca.crt'
mex_cert = 'localserver.crt'
mex_key = 'localserver.key'

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

class tc(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.controller = mex_controller.Controller(controller_address = controller_address,
                                                    root_cert = mex_root_cert,
                                                    key = mex_key,
                                                    client_cert = mex_cert
                                                   )

    def test_CreateAppDeveloperEmpty_Docker(self):
        # [Documentation] App - User shall not be able to create app with empty developername and type Docker
        # ... Create an app with empty developername and type Docker
        # ... verify 'Invalid developer name' is received

        # print the existing apps 
        app_pre = self.controller.show_apps()

        # create the app with no parms
        error = None
        app = mex_controller.App(image_type='ImageTypeDocker',
                                 cluster_name='dummyCluster',
                                 access_ports=access_ports,
                                 developer_name='',
                                 use_defaults=False)
        try:
            resp = self.controller.create_app(app.app)
        except grpc.RpcError as e:
            logger.info('got exception ' + str(e))
            error = e

        # print the cluster instances after error
        app_post = self.controller.show_apps()

        expect_equal(error.code(), grpc.StatusCode.UNKNOWN, 'status code')
        expect_equal(error.details(), 'Invalid developer name', 'error details')
        #expect_equal(len(app_pre), len(app_post), 'same number of apps')
        assert_expectations()

    def test_CreateAppDeveloperEmpty_QCOW(self):
        # [Documentation] App - User shall not be able to create app with empty developername and type QCOW
        # ... Create an app with empty developername and type QCOW
        # ... verify 'Invalid developer name' is received

        # print the existing apps
        app_pre = self.controller.show_apps()

        # create the app with no parms
        error = None
        app = mex_controller.App(image_type='ImageTypeQCOW',
                                 cluster_name='dummyCluster',
                                 access_ports=access_ports,
                                 developer_name='',
                                 use_defaults=False)
        try:
            resp = self.controller.create_app(app.app)
        except grpc.RpcError as e:
            logger.info('got exception ' + str(e))
            error = e

        # print the cluster instances after error
        app_post = self.controller.show_apps()

        expect_equal(error.code(), grpc.StatusCode.UNKNOWN, 'status code')
        expect_equal(error.details(), 'Invalid developer name', 'error details')
        #expect_equal(len(app_pre), len(app_post), 'same number of apps')
        assert_expectations()

    def test_CreateAppDeveloperNotExist_Docker(self):
        # [Documentation] App - User shall not be able to create app with no developername and type Docker
        # ... Create an app with no developername and type Docker
        # ... verify 'Invalid developer name' is received

        # print the existing apps
        app_pre = self.controller.show_apps()

        # create the app with no parms
        error = None
        app = mex_controller.App(image_type='ImageTypeDocker',
                                 cluster_name='dummyCluster',
                                 access_ports=access_ports,
                                 use_defaults=False
                                 )
        try:
            resp = self.controller.create_app(app.app)
        except grpc.RpcError as e:
            logger.info('got exception ' + str(e))
            error = e

        # print the cluster instances after error
        app_post = self.controller.show_apps()

        expect_equal(error.code(), grpc.StatusCode.UNKNOWN, 'status code')
        expect_equal(error.details(), 'Invalid developer name', 'error details')
        #expect_equal(len(app_pre), len(app_post), 'same number of apps')
        assert_expectations()

    def test_CreateAppDeveloperNotExist_QCOW(self):
        # [Documentation] App - User shall not be able to create app with no developername and type QCOW
        # ... Create an app with no developername and type QCOW
        # ... verify 'Invalid developer name' is received

        # print the existing apps
        app_pre = self.controller.show_apps()

        # create the app with no parms
        error = None
        app = mex_controller.App(image_type='ImageTypeQCOW',
                                 cluster_name='dummyCluster',
                                 access_ports=access_ports,
                                 use_defaults=False
                                 )
        try:
            resp = self.controller.create_app(app.app)
        except grpc.RpcError as e:
            logger.info('got exception ' + str(e))
            error = e

        # print the cluster instances after error
        app_post = self.controller.show_apps()

        expect_equal(error.code(), grpc.StatusCode.UNKNOWN, 'status code')
        expect_equal(error.details(), 'Invalid developer name', 'error details')
        #expect_equal(len(app_pre), len(app_post), 'same number of apps')
        assert_expectations()

if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(tc)
    sys.exit(not unittest.TextTestRunner().run(suite).wasSuccessful())

