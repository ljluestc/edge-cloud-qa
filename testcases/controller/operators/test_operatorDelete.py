#!/usr/local/bin/python3

# Operator - User shall be able to delete an operator
#
# delete operator
# verify it is deleted
# 

import unittest
import grpc
import sys
import time
import os
from delayedassert import expect, expect_equal, assert_expectations
import logging

import MexController as mex_controller

controller_address = os.getenv('AUTOMATION_CONTROLLER_ADDRESS', '127.0.0.1:55001')

operator_name = 'operator' + str(time.time())

mex_root_cert = 'mex-ca.crt'
mex_cert = 'mex-client.crt'
mex_key = 'mex-client.key'

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

class tc(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.controller = mex_controller.MexController(controller_address = controller_address,
                                                    root_cert = mex_root_cert,
                                                    key = mex_key,
                                                    client_cert = mex_cert
                                                   )

    def test_deleteOperator(self):
        # print operators before add
        operator_pre = self.controller.show_operators()

        # create operator
        self.operator = mex_controller.Operator(operator_name = operator_name)
        self.controller.create_operator(self.operator.operator)

        # print operators after add
        operator_post = self.controller.show_operators()
        
        # found operator
        found_operator = self.operator.exists(operator_post)
     
        self.controller.delete_operator(self.operator.operator)

        # print operators after delete
        operator_delete = self.controller.show_operators()
        found_operator_delete = self.operator.exists(operator_delete)

        expect_equal(found_operator, True, 'find operator')
        expect_equal(found_operator_delete, False, 'find operator delete')
        expect_equal(len(operator_delete), len(operator_post) - 1, 'num operator')

        assert_expectations()

if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(tc)
    sys.exit(not unittest.TextTestRunner().run(suite).wasSuccessful())

