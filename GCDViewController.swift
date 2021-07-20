//
//  GCDViewController.swift
//
//

///We can do it two ways
///1.Operatiion queue and 2. GCD
//Operation queue is wrappper layer on GCD. Inside GCD we only call or cancel we can not pause and resume so operationqueue is introduced. we can also track if operation finished canceld or running etc states.

//1.//Here we will Cancel task in GCD //Called debounce technique
//2. //Dispatch group

import UIKit

class GCDViewController: UIViewController,UISearchBarDelegate {
    
    var wkItem : DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Called debounce technique
        wkItem?.cancel() //cancel when user add something
        
        wkItem = DispatchWorkItem{
            self.apiCalled(anything: searchBar.text!)
        }
        
        //Dispatch after 3 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: wkItem!)
        
        
        //also we can notify on main thread
        //        wkItem?.notify(queue: .main, execute: {
        //            debugPrint("done dona done")
        //        })
        //        sleep(5) //For sleep
    }
    
    private func apiCalled(anything:String){
        //        here we will call api and reload data
        
    }
    
    
    private func exampleOfDispathcGroup(){
        let dispathchgroup = DispatchGroup()
        
        dispathchgroup.enter()
        //API call 1
        apiCall1 { resp in
            debugPrint(resp)
            dispathchgroup.leave() //Inside closure
        }
        
        dispathchgroup.enter()
        //API call 2
        apiCall1 { resp in
            debugPrint(resp)
            dispathchgroup.leave()
        }
        
        
        dispathchgroup.notify(queue: .main) {
            debugPrint("Both API called parallet")
        }
    }
    
    func apiCall1(completion: @escaping (String) -> Void){
        completion("Any")
    }
    
    
    func operationqueue(){
        //**//
        let empOperation = BlockOperation()
        
        empOperation.addExecutionBlock {
            print("Emp api called")
        }
        
        let deptOperation = BlockOperation()
        deptOperation.addExecutionBlock {
            print("Dept api called")
        }
        
        empOperation.addDependency(deptOperation)
        
        
        let oqueue = OperationQueue()
        oqueue.qualityOfService = .utility
        oqueue.addOperation(empOperation)
        oqueue.addOperation(deptOperation)
        
        //        blockoperation.start()
        //**//
        oqueue.maxConcurrentOperationCount = 3 //only 3 operation at a time
        
    }
    
    func serialQueueusing(){
        
        let serial = DispatchQueue.init(label: "any")
        serial.async {
            print("Call api1")
        }
        serial.async {
            print("Call api2")
        }
        
    }
    
    //above are good but not for URLsession as URL session works in background thread
    
    func sequentialCalling() {
        //Method1. Clousere inside closured Nested approch
        apiCall1 { resp in
            debugPrint(resp)
            self.apiCall1 { resp in //second API
                debugPrint(resp)
            }
        }
        //Method2. Dispatch queue also works paralley
        
        //Method3. RXSwift no use
        
        //Method4. Semaphore - Lock -> But have to test different haveto handle deadlock
        
        //Method5. Dispathcgroup wait leave add
        let dispathchgroup = DispatchGroup()
        apiCall1 { resp in
            debugPrint(resp)
            dispathchgroup.leave() //Inside closure
            
            dispathchgroup.wait()
        }
        
        dispathchgroup.enter()
        //API call 2
        apiCall1 { resp in
            debugPrint(resp)
            dispathchgroup.leave()
        }
        
    }
    
}
