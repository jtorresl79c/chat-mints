# Terms and conditions
class TermsAndConditionsController < ApplicationController
  def index
    update_meta_tags(
      {
        'open_graph' => {
          'title' => 'Términos y Condiciones',
          'url' => '',
          'description' => 'Términos y Condiciones',
          'image' => nil,
          'type' => "website"
        }
      },
      'Términos y condiciones',
      'Página de términos y condiciones',
      'Términos Condiciones'
    )
  end
end
