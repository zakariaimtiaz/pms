package service

import com.pms.PmServiceSector
import grails.transaction.Transactional
import pms.BaseService

@Transactional
class PmServiceSectorService extends BaseService{

    def activeList() {
        List<PmServiceSector> lst = PmServiceSector.findAllByIsDisplayble(true,[sort: "sequence",order: "asc"])
        lst = listForKendoDropdown(lst, null, null)
        return lst
    }
    def categoryWiseServiceList(long categoryId) {
        List<PmServiceSector> lst = PmServiceSector.findAllByCategoryId(categoryId, [sort: 'sequence', order: 'asc'])
        lst = listForKendoDropdown(lst, null, null)
        return lst
    }
}
