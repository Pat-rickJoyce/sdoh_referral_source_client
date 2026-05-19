module SocialRisksHelper
  include SessionHelper

  def fetch_social_risk_assessments
    client = get_client
    response = client.search(
      FHIR::QuestionnaireResponse,
      search: {
        parameters: {
          subject: "Patient/#{patient_id}",
          _sort: "-authored",
        },
      },
    )

    if response.response[:code] == 200 && response.resource.is_a?(FHIR::Bundle)
      entries = response.resource.entry&.map(&:resource) || []
      [true, entries.map { |entry| QuestionnaireResponse.new(entry) }]
    else
      Rails.logger.error("Failed to fetch social risk assessments. Status: #{response.response[:code]} - #{response.response[:body]}")
      [false, "Failed to fetch social risk assessments."]
    end
  rescue StandardError => e
    Rails.logger.error(e.full_message)
    [false, "Failed to fetch social risk assessments. #{e.message}"]
  end
end
