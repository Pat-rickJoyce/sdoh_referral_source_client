# Purpose: Contails valuesets, code systems, and other constants used in Goal resource
module GoalDefinitionsHelper
  def achievement_status
    [
      { code: "in-progress", display: "In progress" },
      { code: "improving", display: "Improving" },
      { code: "worsening", display: "Worsening" },
      { code: "no-change", display: "No Change" },
      { code: "achieved", display: "Achieved" },
      { code: "sustaining", display: "Sustaining" },
      { code: "not-achieved", display: "Not Achieved" },
      { code: " no-progress", display: "No Progress" },
      { code: "not-attainable", display: "Not Attainable" },
    ]
  end

  def goal_category
    [
      {
        code: "sdoh-category-unspecified",
        display: "SDOH Category Unspecified"
      },
      {
        code: "food-insecurity",
        display: "Food Insecurity"
      },
      {
        code: "housing-instability",
        display: "Housing Instability"
      },
      {
        code: "homelessness",
        display: "Homelessness"
      },
      {
        code: "inadequate-housing",
        display: "Inadequate Housing"
      },
      {
        code: "transportation-insecurity",
        display: "Transportation Insecurity"
      },
      {
        code: "financial-insecurity",
        display: "Financial Insecurity"
      },
      {
        code: "material-hardship",
        display: "Material Hardship"
      },
      {
        code: "educational-attainment",
        display: "Educational Attainment"
      },
      {
        code: "employment-status",
        display: "Employment Status"
      },
      {
        code: "veteran-status",
        display: "Veteran Status"
      },
      {
        code: "stress",
        display: "Stress"
      },
      {
        code: "social-connection",
        display: "Social Connection"
      },
      {
        code: "intimate-partner-violence",
        display: "Intimate Partner Violence"
      },
      {
        code: "elder-abuse",
        display: "Elder Abuse"
      },
      {
        code: "personal-health-literacy",
        display: "Personal Health Literacy"
      },
      {
        code: "health-insurance-coverage-status",
        display: "Health Insurance Coverage Status"
      },
      {
        code: "medical-cost-burden",
        display: "Medical Cost Burden"
      },
      {
        code: "digital-literacy",
        display: "Digital Literacy"
      },
      {
        code: "digital-access",
        display: "Digital Access"
      },
      {
        code: "utility-insecurity",
        display: "Utility Insecurity"
      },
      {
        code: "incarceration-status",
        display: "Incarceration Status"
      },
      {
        code: "language-access",
        display: "Language Access"
      }
    ]
  end

  # system": "http://snomed.info/sct
  GOAL_DESCRIPTIONS = {
    "611271000124109" => "Transportation security (finding)",
    "611461000124101" => "Able to afford transportation-related expense (finding)",
    "611491000124109" => "Has transportation that meets individual's cognitive needs (finding)",
    "611511000124103" => "Has transportation to access community resources (finding)",
    "611521000124106" => "Has transportation to access health care (finding)",
    "1078229009" => "Food security (finding)",
    "611211000124100" => "Housing security (finding)",
    "611221000124108" => "Stably housed (finding)",
  }
end
