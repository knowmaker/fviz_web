# frozen_string_literal: true

module QuantitiesHelper
  def generate_html_table(quantities)
    grouped_quantities = quantities.group_by(&:gk_sign)

    html = "<html><head><title>Quantities Tables</title>"
    html += "<style>
              table {
                border-collapse: collapse;
                width: 100%;
              }
              th, td {
                border: 1px solid black;
                padding: 8px;
                text-align: left;
              }
              th {
                background-color: #f2f2f2;
              }
            </style>"
    html += "</head><body>"

    grouped_quantities.each do |gk_sign, quantities_group|
      html += "<h1>Quantities Table for GK Sign: #{gk_sign}</h1>"
      html += "<table><thead><tr><th>Name</th><th>Value</th><th>Unit</th></tr></thead><tbody>"

      quantities_group.each do |quantity|
        html += <<-HTML
        <tr>
          <td>#{quantity.val_name}</td>
          <td>#{quantity.symbol}</td>
          <td>#{quantity.unit}</td>
        </tr>
        HTML
      end

      html += "</tbody></table>"
    end

    html += "</body></html>"
    html
  end
end
