module GoalsHelper
  include SessionHelper

  def save_goals(goals)
    Rails.cache.write(goals_key, goals, expires_in: 1.minute)
  rescue StandardError => e
    Rails.logger.error(e.full_message)
  end

  def fetch_goals
    response = get_client.search(FHIR::Goal, search: { parameters: { subject: patient_id, _sort: "-_lastUpdated" }}).resource
    if response.is_a?(FHIR::Bundle)
      entries = response.entry.map(&:resource)
      goals = entries.map { |entry| Goal.new(entry, fhir_client: get_client) }
      grp = {"active" => [], "completed" => []}
      goals.each { |goal| goal.achievement_status != "Achieved" ? grp["active"] << goal : grp["completed"] << goal }
      save_goals(grp)
      grp
    else
      raise "Failed to fetch patient's goals."
    end
  end

  # system": "http://snomed.info/sct
  def description_options
  {
        "language-access" => [
            ["Able to communicate (finding)", "288575003"],
        ],
        "incarceration-status" => [
            ["Food security (finding)", "1078229009"],
            ["Has access to transportation (finding)", "1137434003"],
            ["Feeling more empowered (finding)", "1144481009"],
            ["Self efficacy (finding)", "1156332000"],
            ["Adequate social connection (finding)", "1230391007"],
            ["Not feeling lonely (finding)", "1230392000"],
            ["Adequate social participation (finding)", "1230393005"],
            ["Feels social relationships are satisfying and sufficient (finding)", "1300103006"],
            ["Completed vocational education program (finding)", "1300105004"],
            ["Financially secure (finding)", "224165006"],
            ["Income sufficient to meet needs (finding)", "224190007"],
            ["Employed (finding)", "224363007"],
            ["Confident (finding)", "225486005"],
            ["Hopeful for the future (finding)", "225649001"],
            ["Able to maintain self-esteem (finding)", "225973006"],
            ["Satisfied with job (finding)", "302124002"],
            ["Enrolled in Medicaid health insurance coverage (finding)", "433641000124108"],
            ["Received vocational training (finding)", "440586004"],
            ["Receives as much social support as wanted (finding)", "445091000124106"],
            ["Feeling safe (finding)", "449892005"],
            ["Able to access healthcare services (finding)", "460821000124100"],
            ["Received certificate of high school equivalency (finding)", "5251000175109"],
            ["Housing security (finding)", "611211000124100"],
            ["Stably housed (finding)", "611221000124108"],
            ["Able to be hopeful for future (finding)", "719143004"],
            ["Completed Restorative Justice Program (finding)", "761281000124104"],
        ],
        "utility-insecurity" => [
            ["Adequate cooling in residence (finding)", "1204361005"],
            ["Adequate heating in residence (finding)", "1204362003"],
            ["Able to afford electricity in residence (finding)", "1268657007"],
            ["Able to afford cooling in residence (finding)", "1268659005"],
            ["Able to afford utilities in residence (finding)", "1268689003"],
            ["Able to afford heating in residence (finding)", "1268777006"],
        ],
        "digital-access" => [
            ["Able to afford internet service (finding)", "1268660000"],
        ],
        "digital-literacy" => [
            ["Adequate foundation level digital literacy skills (finding)", "851251000124102"],
         ],
        "medical-cost-burden" => [
            ["Able to afford medication (finding)", "1268779009"],
            ["Financially secure (finding)", "224165006"],
            ["Able to afford medical expenses (finding)", "671351000124100"],
        ],
        "health-insurance-coverage-status" => [
            ["Private health insurance held (finding)", "185952002"],
            ["Enrolled in Department of Veterans Affairs health insurance coverage (finding)", "432681000124109"],
            ["Enrolled in employee group health insurance coverage (finding)", "432691000124107"],
            ["Enrolled in Medicaid health insurance coverage (finding)", "433641000124108"],
            ["Enrolled in Medicare advantage health insurance coverage (finding)", "433651000124105"],
            ["Enrolled in Medicare health insurance coverage (finding)", "433661000124107"],
            ["Enrolled in Indian Health Service coverage (finding)", "671181000124106"],
            ["Enrolled in Children's Health Insurance Program (finding)", "671191000124109"],
            ["Enrolled in Medicare drug plan (finding)", "671231000124104"],
            ["Enrolled in Tricare health insurance (finding)", "671241000124109"],
            ["Enrolled in Medigap health insurance (finding)", "671251000124106"],
        ],
        "personal-health-literacy" => [
            ["Has access to understandable information for health-related decisions (finding)", "1256110003"],
            ["Able to demonstrate health literacy (finding)", "871870009"],
        ],
        "elder-abuse" => [
            ["Adequate social connection (finding)", "1230391007"],
            ["Financially secure (finding)", "224165005"],
            ["Receives as much social support as wanted (finding)", "445091000124106"],
            ["Feeling safe (finding)", "449892005"],
            ["No known elder sexual abuse (situation)", "591131000124107"],
            ["No known elder physical abuse (situation)", "591141000124102"],
            ["No known elder psychological abuse (situation)", "591151000124100"],
            ["No known elder financial abuse (situation)", "591161000124103"],
            ["No known elder neglect (situation)", "591171000124105"],
            ["No known elder abuse (situation)", "591181000124108"],
            ["Victim of abuse with enhanced social monitoring (finding)", "611471000124108"],
            ["Victim of abuse with limited perpetrator access to victim (finding)", "611481000124106"],
            ["Residence adequately secure from intruder (finding)", "611541000124104"],
            ["No known elder financial exploitation (situation)", "761151000124104"],
            ["Completed Restorative Justice Program (finding)", "761281000124104"],
        ],
        "intimate-partner-violence" => [
            ["Food security (finding)", "1078229009"],
            ["Good recovery from sexual assault (finding)", "1144537004"],
            ["Adequate social connection (finding)", "1230391007"],
            ["No known sexual abuse (situation)", "1268688006"],
            ["No known physical abuse (situation)", "1268729006"],
            ["No known psychological abuse (situation)", "1268730001"],
            ["Financially secure (finding)", "224165006"],
            ["Receives as much social support as wanted (finding)", "445091000124106"],
            ["Feeling safe (finding)", "449892005"],
            ["Stably housed (finding)", "611221000124108"],
            ["Transportation security (finding)", "611271000124109"],
            ["Victim of abuse with enhanced social monitoring (finding)", "611471000124108"],
            ["Victim of abuse with limited perpetrator access to victim (finding)", "611481000124106"],
            ["Residence adequately secure from intruder (finding)", "611541000124104"],
            ["Completed Restorative Justice Program (finding)", "761281000124104"],
        ],
        "social-connection" => [
            ["Adequate social connection (finding)", "1230391007"],
            ["Not feeling lonely (finding)", "1230392000"],
            ["Adequate social participation (finding)", "1230393005"],
            ["Feels social relationships are satisfying and sufficient (finding)", "1300103006"],
            ["Receives as much social support as wanted (finding)", "445091000124106"],
        ],
        "stress" => [
            ["Receives as much social support as wanted (finding)", "445091000124106"],
            ["Able to manage stress (finding)", "716421004"],
        ],
        "veteran-status" => [
            ["Eligible for Veterans Affairs benefits (finding)", "671221000124102"],
            ["Honorable discharge from military service (finding)", "671481000124104"],
            ["Eligible for Department of Veterans Affairs National Cemetery Administration burial and memorial benefits (finding)", "761361000124104"],
        ],
        "material-hardship" => [
            ["Able to afford electricity in residence (finding)", "1268657007"],
            ["Able to afford adequate clothing (finding)", "1268658002"],
            ["Able to afford cooling in residence (finding)", "1268659005"],
            ["Able to afford internet service (finding)", "1268660000"],
            ["Able to afford childcare (finding)", "1268661001"],
            ["Able to afford utilities in residence (finding)", "1268689003"],
            ["Able to afford dependent adult care (finding)", "1268690007"],
            ["Able to afford heating in residence (finding)", "1268777006"],
            ["Able to afford telephone (finding)", "1268778001"],
            ["Able to afford medical expenses (finding)", "671351000124100"],
            ["Able to obtain medication (finding)", "715045000"],
        ],
        "financial-insecurity" => [
            ["Financially secure (finding)", "224165006"],
        ],
        "transportation-insecurity" => [
            ["Has access to transportation (finding)", "1137434003"],
            ["Feels transportation time to destination is acceptable (finding)", "1268687001"],
            ["Transportation security (finding)", "611271000124109"],
            ["Able to afford transportation related expense (finding)", "611461000124101"],
            ["Has transportation that meets cognitive needs (finding)", "611491000124109"],
            ["Has transportation that meets functional needs (finding)", "611501000124101"],
            ["Has transportation to access community resources (finding)", "611511000124103"],
            ["Has transportation to access health care (finding)", "611521000124106"],
        ],
        "inadequate-housing" => [
            ["Adequate equipment for safe food storage in residence (finding)", "1204359001"],
            ["Adequate food preparation equipment in residence (finding)", "1204360006"],
            ["Adequate cooling in residence (finding)", "1204361005"],
            ["Adequate heating in residence (finding)", "1204362003"],
            ["No known lead in residence (situation)", "1208721001"],
            ["No known infestation in residence (situation)", "1208722008"],
            ["No known mold in residence (situation)", "1208723003"],
            ["No known asbestos in residence (situation)", "1208724009"],
            ["No known radon in residence (situation)", "1208791005"],
            ["Housing adequate (finding)", "161036002"],
            ["Housing problem solved (finding)", "185960001"],
            ["No known code violation in residence (situation)", "591101000124104"],
            ["No known structural insufficiency in residence (situation)", "591111000124101"],
            ["No known overcrowding in residence (situation)", "591121000124109"],
            ["Residence meets functional needs (finding)", "611171000124102"],
            ["Functioning fire extinguisher in residence (finding)", "611231000124106"],
            ["Functioning carbon monoxide detector in residence (finding)", "611241000124101"],
            ["Functioning smoke detector in residence (finding)", "611251000124104"],
            ["Functioning sink in residence (finding)", "611261000124102"],
            ["Functioning toilet in residence (finding)", "651021000124108"],
        ],
         "homelessness" => [
            ["Unsheltered homelessness, sleeping in safe environment (finding)", "611181000124104"],
            ["Stably housed (finding)", "611221000124108"],
         ],
         "housing-instability" => [
            ["Housing security (finding)", "611211000124100"],
            ["Stably housed (finding)", "611221000124108"],
        ],
        "food-insecurity" => [
            ["Food security (finding)", "1078229009"],
            ["Feels food intake quantity is adequate for meals and snacks (finding)", "671311000124101"],
            ["Feels food intake quantity is adequate for snacks (finding)", "671321000124109"],
            ["Feels food intake quantity is adequate for meals (finding)", "671331000124107"],
        ],
        "educational-attainment" => [
            ["Completed basic skills training program (finding)", "1300104000"],
            ["Completed vocational education program (finding)", "1300105004"],
            ["Completed English as a second language program (finding)", "1300106003"],
            ["Completed adult learning center program (finding)", "1300107007"],
            ["Educated to high school level (finding)", "473461003"],
            ["Received certificate of high school equivalency (finding)", "5251000175109"],
            ["Completed early-college high school program (finding)", "761261000124109"],
        ],
        "employment-status" => [
            ["Full-time employment (finding)", "160903007"],
            ["Part-time employment (finding)", "160904001"],
            ["Self-employed (finding)", "160906004"],
            ["Employed (finding)", "224363007"],
            ["In paid employment (finding)", "406156006"],
            ["Received vocational training (finding)", "440586004"],
            ["Self-employed paid work (finding)", "452101000124107"],
            ["Self-employed unpaid work (finding)", "452111000124105"],
            ["Paid work in United States armed forces (finding)", "452121000124102"],
            ["Paid work in United States federal government (finding)", "452131000124104"],
            ["Paid work not self-employed (finding)", "452141000124109"],
            ["Unpaid work not self-employed (finding)", "452151000124106"],
            ["Paid work in local government (finding)", "452491000124108"],
            ["Paid work in state government (finding)", "452501000124100"],
            ["Receiving unemployment benefits (finding)", "671411000124106"],
            ["Has workforce training (finding)", "761521000124100"],
        ],
      }
  end
end
