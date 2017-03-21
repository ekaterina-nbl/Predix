// Copyright (c) 2017 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

const UAA_URL                   = "#{env:PREDIX_UAA_URL}";
const CLIENT_ID                 = "#{env:PREDIX_CLIENT_ID}";
const CLIENT_SECRET             = "#{env:PREDIX_CLIENT_SECRET}";
const ASSET_URL                 = "#{env:PREDIX_ASSET_URL}";
const ASSET_ZONE_ID             = "#{env:PREDIX_ASSET_ZONE_ID}";
const TIME_SERIES_INGEST_URL    = "#{env:PREDIX_TIME_SERIES_INGEST_URL}";
const TIME_SERIES_ZONE_ID       = "#{env:PREDIX_TIME_SERIES_ZONE_ID}";

const ASSET_TYPE = "test_device";
const ASSET_ID = "id_123";

// Test case for deleteAsset method of Predix library
class DeleteAssetTestCase extends ImpTestCase {
    _assetInfo = {
        "description" : "test device",
        "location" : "home"
    };

    _predix = null;

    // Initializes Predix library
    function setUp() {
        _predix = Predix(UAA_URL, CLIENT_ID, CLIENT_SECRET, 
            ASSET_URL, ASSET_ZONE_ID, TIME_SERIES_INGEST_URL, TIME_SERIES_ZONE_ID);
    }

    // Tests deleteAsset
    function testDeleteAsset() {
        return Promise(function (resolve, reject) {
            _predix.createAsset(ASSET_TYPE, ASSET_ID, _assetInfo, function(status, errMessage, response) {
                if (status != PREDIX_STATUS.SUCCESS) {
                    return reject("createAsset failed:" + errMessage);
                }
                _predix.deleteAsset(ASSET_TYPE, ASSET_ID, function(status, errMessage, response) {
                    if (status != PREDIX_STATUS.SUCCESS) {
                        return reject("deleteAsset failed:" + errMessage);
                    }
                    _predix.queryAsset(ASSET_TYPE, ASSET_ID, function(status, errMessage, response) {
                        if (status == PREDIX_STATUS.SUCCESS) {
                            return reject("asset is not deleted!");
                        }
                        return resolve("");
                    }.bindenv(this));
                }.bindenv(this));
            }.bindenv(this));
        }.bindenv(this));
    }

    // Tests multiple deleteAsset. deleteAsset should return PREDIX_STATUS.SUCCESS 
    // even if the asset doesn't exist.
    function testMultipleDeleteAsset() {
        return Promise(function (resolve, reject) {
            _predix.createAsset(ASSET_TYPE, ASSET_ID, _assetInfo, function(status, errMessage, response) {
                if (status != PREDIX_STATUS.SUCCESS) {
                    return reject("createAsset failed:" + errMessage);
                }
                _predix.deleteAsset(ASSET_TYPE, ASSET_ID, function(status, errMessage, response) {
                    if (status != PREDIX_STATUS.SUCCESS) {
                        return reject("deleteAsset failed:" + errMessage);
                    }
                    _predix.deleteAsset(ASSET_TYPE, ASSET_ID, function(status, errMessage, response) {
                        if (status != PREDIX_STATUS.SUCCESS) {
                            return reject("deleteAsset2 failed:" + errMessage);
                        }
                        _predix.deleteAsset(ASSET_TYPE, ASSET_ID, function(status, errMessage, response) {
                            if (status != PREDIX_STATUS.SUCCESS) {
                                return reject("deleteAsset3 failed:" + errMessage);
                            }
                            _predix.queryAsset(ASSET_TYPE, ASSET_ID, function(status, errMessage, response) {
                                if (status == PREDIX_STATUS.SUCCESS) {
                                    return reject("asset is not deleted!");
                                }
                                return resolve("");
                            }.bindenv(this));
                        }.bindenv(this));
                    }.bindenv(this));
                }.bindenv(this));
            }.bindenv(this));
        }.bindenv(this));
    }

    // Tests deleteAsset without callback
    function testDeleteAssetWithoutCallback() {
        return Promise(function (resolve, reject) {
            _predix.createAsset(ASSET_TYPE, ASSET_ID, _assetInfo, function(status, errMessage, response) {
                if (status != PREDIX_STATUS.SUCCESS) {
                    return reject("createAsset failed:" + errMessage);
                }
                _predix.deleteAsset(ASSET_TYPE, ASSET_ID);
                imp.wakeup(5, function() {
		    return resolve("");
		});
            }.bindenv(this));
        }.bindenv(this));
    }
}

