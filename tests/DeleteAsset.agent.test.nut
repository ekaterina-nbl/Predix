// MIT License
//
// Copyright 2017 Electric Imp
//
// SPDX-License-Identifier: MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

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

