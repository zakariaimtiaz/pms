package pms

import com.logic27.awls.crypto.CryptoUtil
import grails.converters.JSON
import pms.utility.Tools

class CryptoUtilController extends BaseController {


    def show(){
        render(view: '/cryptoUtil/show')
    }

    def encryptTxt(){
        String txt1 = params.input1
        String txt2 = params.input2

        CryptoUtil cryptoUtil = new CryptoUtil();
        String output1 = txt1.equals('')?'':cryptoUtil.encrypt(Tools.FLASK,txt1);
        String output2 = txt2.equals('')?'':cryptoUtil.encrypt(Tools.FLASK,txt2);
        def map = [:]
        map.put('output1',output1)
        map.put('output2',output2)
        render map as JSON

    }
    def decryptTxt(){
        String txt1 = params.input1
        String txt2 = params.input2
        String output1
        String output2

        CryptoUtil cryptoUtil = new CryptoUtil();
        try {
            output1 = cryptoUtil.decrypt(Tools.FLASK,txt1);
        } catch (Exception ex) {
            output1 = cryptoUtil.encrypt(Tools.FLASK,txt1);
            output1 = cryptoUtil.decrypt(Tools.FLASK,output1);
        }
        try {
            output2 = cryptoUtil.decrypt(Tools.FLASK,txt2);
        } catch (Exception ex) {
            output2 = cryptoUtil.encrypt(Tools.FLASK,txt2);
            output2 = cryptoUtil.decrypt(Tools.FLASK,output2);
        }
        def map = [:]
        map.put('output1',output1)
        map.put('output2',output2)
        render map as JSON
    }
}
