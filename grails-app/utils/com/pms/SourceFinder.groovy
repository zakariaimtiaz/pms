package com.pms

import com.logic27.awls.crypto.CryptoUtil
import pms.utility.Tools

class SourceFinder {

    public static String findAppropriate(String cryptedData) {
        String formalData = ''
        try {
            if (cryptedData == null){
                throw new RuntimeException('cryptedData can not be null')
            } else if (cryptedData?.length() <= 0){
                throw new RuntimeException('cryptedData length can not be 0')
            }

            CryptoUtil cryptoUtil = new CryptoUtil();
            formalData = cryptoUtil.decrypt(Tools.FLASK,cryptedData);

        } catch (Exception ex) {
            throw new RuntimeException(ex)
        }
        return formalData
    }

}
