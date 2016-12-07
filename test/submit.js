/*
 * IBM Confidential
 * OCO Source Materials
 * IBM Concerto - Blockchain Solution Framework
 * Copyright IBM Corp. 2016
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 */

'use strict';

const Client = require('@ibm/ibm-concerto-client');
const Admin = require('@ibm/ibm-concerto-admin');
const Common = require('@ibm/ibm-concerto-common');
const BusinessNetworkConnection = Client.BusinessNetworkConnection;
const BusinessNetworkDefinition = Admin.BusinessNetworkDefinition;
const Serializer = Common.Serializer;
const Resource = Common.Resource;


const CmdUtil = require('./../lib/utils/cmdutils');

const Submit = require('./../lib/submit');
const chai = require('chai');
const sinon = require('sinon');

require('sinon-as-promised');
chai.should();
chai.use(require('chai-things'));
chai.use(require('chai-as-promised'));
// let expect = chai.expect;

const NAMESPACE = 'net.biz.TestNetwork';
const BUSINESS_NETWORK_NAME = 'net.biz.TestNetwork-0.0.1';
const DEFAULT_PROFILE_NAME = 'defaultProfile';
const ENROLL_ID = 'SuccessKid';
const ENROLL_SECRET = 'SuccessKidWin';

//const DEFAULT_PROFILE_NAME = 'defaultProfile';
// const CREDENTIALS_ROOT = homedir() + '/.concerto-credentials';


describe('#concerto transaction submit', () => {
    let sandbox;
    let mockBusinessNetworkConnection;
    let mockBusinessNetwork;
    let mockSerializer;
    let mockResource;

    beforeEach(() => {
        sandbox = sinon.sandbox.create();
        mockBusinessNetworkConnection = sinon.createStubInstance(BusinessNetworkConnection);
        mockBusinessNetwork = sinon.createStubInstance(BusinessNetworkDefinition);
        mockSerializer = sinon.createStubInstance(Serializer);
        mockResource = sinon.createStubInstance(Resource);
        mockBusinessNetworkConnection.getBusinessNetwork.returns(mockBusinessNetwork);
        mockBusinessNetwork.getSerializer.returns(mockSerializer);
        mockSerializer.fromJSON.returns(mockResource);
        mockResource.getIdentifier.returns('SuccessKid');

        sandbox.stub(CmdUtil, 'createBusinessNetworkConnection').returns(mockBusinessNetworkConnection);
    });

    afterEach(() => {
        sandbox.restore();
    });

    describe('#hander', () => {
        it('should submit a transaction when all requred params are specified', () => {
            let argv = {
                connectionProfileName: DEFAULT_PROFILE_NAME,
                businessNetworkName: BUSINESS_NETWORK_NAME,
                enrollId: ENROLL_ID,
                enrollSecret: ENROLL_SECRET,
                args: '{"$class": "'+NAMESPACE+'", "success": "true"}'
            };

            return Submit.handler(argv)
            .then((res) => {
                sinon.assert.calledOnce(mockBusinessNetworkConnection.connect);
                sinon.assert.calledWith(mockBusinessNetworkConnection.connect, argv.connectionProfileName, argv.businessNetworkName, argv.enrollId, argv.enrollSecret);
                sinon.assert.calledOnce(mockBusinessNetworkConnection.getBusinessNetwork);
                sinon.assert.calledOnce(mockBusinessNetwork.getSerializer);
                sinon.assert.calledOnce(mockSerializer.fromJSON);
                sinon.assert.calledWith(mockSerializer.fromJSON, JSON.parse(argv.args));
            });
        });

        it('should not error when connection profile name is not given', () => {

            let argv = {
                businessNetworkName: BUSINESS_NETWORK_NAME,
                enrollId: ENROLL_ID,
                enrollSecret: ENROLL_SECRET,
                args: '{"$class": "'+NAMESPACE+'", "success": "true"}'
            };

            return Submit.handler(argv)
            .then((res) => {
                sinon.assert.calledOnce(mockBusinessNetworkConnection.connect);
                sinon.assert.calledWith(mockBusinessNetworkConnection.connect, 'defaultProfile', argv.businessNetworkName, argv.enrollId, argv.enrollSecret);
                sinon.assert.calledOnce(mockBusinessNetworkConnection.getBusinessNetwork);
                sinon.assert.calledOnce(mockBusinessNetwork.getSerializer);
                sinon.assert.calledOnce(mockSerializer.fromJSON);
                sinon.assert.calledWith(mockSerializer.fromJSON, JSON.parse(argv.args));
            });
        });

        it('should not error when all requred params are specified', () => {
            sandbox.stub(CmdUtil, 'prompt').resolves(ENROLL_SECRET);

            let argv = {
                connectionProfileName: DEFAULT_PROFILE_NAME,
                businessNetworkName: BUSINESS_NETWORK_NAME,
                enrollId: ENROLL_ID,
                args: '{"$class": "'+NAMESPACE+'", "success": "true"}'
            };

            return Submit.handler(argv)
            .then((res) => {
                sinon.assert.calledWith(CmdUtil.prompt);
            });
        });
    });
});
