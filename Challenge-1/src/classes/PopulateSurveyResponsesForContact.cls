global class PopulateSurveyResponsesForContact implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([select id, name, Contact__c, Question__c , Response__c, Survey__c from Survey_Response__c]);
    }
    
    global void execute(Database.BatchableContext bc, List<Survey_Response__c> surveyResponses){
        Map<Id,List<String> > mapOfContactWithResponses = new Map<Id, List<String>>();
        for(Survey_Response__c sResponse: surveyResponses){
            if(mapOfContactWithResponses.containsKey(sResponse.Contact__c)){
                List<String> responses  = mapOfContactWithResponses.get(sResponse.Contact__c);
                responses.add(sResponse.Response__c);
            }else{
                List<String> responses = new List<String>();
                responses.add(sResponse.Response__c);
                mapOfContactWithResponses.put(sResponse.Contact__c, responses);
            }
        }
        
        List<Contact> listOfContactsToUpdate = new List<Contact>();
        for(Contact contact: [select id, name, All_Survey_Responses__c from Contact where id in:mapOfContactWithResponses.keySet()]){
            String allResponses = '';
            if(mapOfContactWithResponses.containsKey(contact.id)){
                allResponses = String.join(mapOfContactWithResponses.get(contact.id), ',');
                contact.All_Survey_Responses__c = allResponses;
                listOfContactsToUpdate.add(contact);
            }
            
        }
        
        if(listOfContactsToUpdate.size() > 0)
            update listOfContactsToUpdate;
    }   
    
    global void finish(Database.BatchableContext bc){
    }   
}