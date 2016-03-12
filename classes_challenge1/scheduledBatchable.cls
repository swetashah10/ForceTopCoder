global class scheduledBatchable implements Schedulable {

   global void execute(SchedulableContext sc) {
      PopulateSurveyResponsesForContact b = new PopulateSurveyResponsesForContact();
      database.executebatch(b);
   }
}