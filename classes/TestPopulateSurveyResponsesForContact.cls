@istest
class TestPopulateSurveyResponsesForContact {
    public static void setup(){
        // Create a survey
        Survey__c survey1 = new Survey__c(name='Survey1', Description__c = 'Some Survey!');
        insert survey1;
        // Create a question
        List<Question__c> ques = new List<Question__c>();
        Question__c que1 = new Question__c(name='que1', Question_Text__c = 'What is your name?');
        Question__c que2 = new Question__c(name='que2', Question_Text__c = 'What is your profession?');
        
        insert que1;
        insert que2;
        
        // Insert Survey Questions
        List<Survey_Question__c> listOfSurveyQues = new List<Survey_Question__c>();
        Survey_Question__c surveyQues1 = new Survey_Question__c(Survey__c = survey1.id, Question__c = que1.id);
        Survey_Question__c surveyQues2 = new Survey_Question__c(Survey__c = survey1.id, Question__c = que2.id);
        
        listOfSurveyQues.add(surveyQues1);
        listOfSurveyQues.add(surveyQues2);
        insert listOfSurveyQues;
        
        // create a contact
        Contact contact1 = new Contact(lastname='Sakshi Sinha', Survey__c = survey1.id);
        insert contact1;
        
        Contact contact2 = new Contact(lastname='Arpit Sinha', Survey__c = survey1.id);
        insert contact2;
        // create survey response
        Survey_Response__c surveyResponse1 = new Survey_Response__c(Contact__c = contact1.Id, Survey__c = survey1.id, Question__c = que1.id, Response__c='My name is Sakshi Sinha.');
        Survey_Response__c surveyResponse2 = new Survey_Response__c(Contact__c = contact1.Id, Survey__c = survey1.id, Question__c = que2.id, Response__c='I am a Software Professional.');
        
        Survey_Response__c surveyResponse3 = new Survey_Response__c(Contact__c = contact2.Id, Survey__c = survey1.id, Question__c = que1.id, Response__c='My name is Arpit Sinha.');
        Survey_Response__c surveyResponse4 = new Survey_Response__c(Contact__c = contact2.Id, Survey__c = survey1.id, Question__c = que2.id, Response__c='I am an Entrepreneur.');
        
        insert surveyResponse1;
        insert surveyResponse2;
        insert surveyResponse3;
        insert surveyResponse4;
    }
    static testmethod void TestPopulateSurveyResponses(){   
        setup();
        Test.StartTest();
        PopulateSurveyResponsesForContact populateSurveyResponses = new PopulateSurveyResponsesForContact();
        ID batchprocessid = Database.executeBatch(populateSurveyResponses);
        Test.StopTest();
        System.assert( batchprocessid != null );
        // assert if the string is created and Contact.All_Survey_Responses__c is populated.  
        Contact contact = [select id, name, All_Survey_Responses__c from Contact where lastname like 'Sakshi Sinha'];
        System.assert(!String.isBlank(contact.All_Survey_Responses__c) , 'All Survey Responses should be populated but is: '+contact.All_Survey_Responses__c);
        System.debug('All_Survey_Responses__c: '+contact.All_Survey_Responses__c);
        
        Contact contact2 = [select id, name, All_Survey_Responses__c from Contact where lastname like 'Arpit Sinha'];
        System.assert(!String.isBlank(contact2.All_Survey_Responses__c) , 'All Survey Responses should be populated but is: '+contact2.All_Survey_Responses__c);
        System.debug('All_Survey_Responses__c contact2: '+contact2.All_Survey_Responses__c);
    }
}