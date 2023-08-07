# frozen_string_literal: true

module QuantitiesHelper
  def generate_html_table(quantities)
    html = <<-HTML
      <html>
        <head>
          <title>Quantities Table</title>
        </head>
        <body>
          <h1>Quantities Table</h1>
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Value</th>
              </tr>
            </thead>
            <tbody>
    HTML

    quantities.each do |quantity|
      html += <<-HTML
        <tr>
          <td>#{quantity.id_value}</td>
          <td>#{quantity.val_name}</td>
          <td>#{quantity.symbol}</td>
        </tr>
      HTML
    end

    html += <<-HTML
            </tbody>
          </table>
        </body>
      </html>
    HTML

    html
  end
end
