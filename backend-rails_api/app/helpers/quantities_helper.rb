# frozen_string_literal: true

# Модуль дополнительных функций для работы с методами класса величин
module QuantitiesHelper
  def generate_html_table(quantities)
    grouped_quantities = quantities.group_by { |quantity| [quantity.g_indicate, quantity.k_indicate] }

    html = "<html lang='en'><head><meta charset='UTF-8'><title>Таблица всех физических величин в системе</title>"
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
    html += '</head><body>'

    grouped_quantities.each do |indicates, quantities_group|
      g_indicate, k_indicate = indicates
      html += "<h1>Таблица величин для G<sup>#{g_indicate}</sup>K<sup>#{k_indicate}</sup></h1>"
      html += '<table><thead><tr><th>Название</th><th>Обозначение</th><th>Ед. измер.</th><th>MLTI</th></tr></thead><tbody>'

      quantities_group.each do |quantity|
        html += <<-HTML
        <tr>
          <td>#{quantity.value_name}</td>
          <td>#{quantity.symbol}</td>
          <td>#{quantity.unit}</td>
          <td>#{generate_mlti(quantity.m_indicate_auto, quantity.l_indicate_auto, quantity.t_indicate_auto, quantity.i_indicate_auto)}</td>
        </tr>
        HTML
      end

      html += '</tbody></table>'
    end

    html += '</body></html>'
    html
  end

  def generate_mlti(m_indicate, l_indicate, t_indicate, i_indicate)
    mlti_string = ''

    mlti_string += "M<sup>#{m_indicate}</sup>" if m_indicate != 0

    mlti_string += "L<sup>#{l_indicate}</sup>" if l_indicate != 0

    mlti_string += "T<sup>#{t_indicate}</sup>" if t_indicate != 0

    mlti_string += "I<sup>#{i_indicate}</sup>" if i_indicate != 0

    if m_indicate.zero? && l_indicate.zero? && t_indicate.zero? && i_indicate.zero?
      mlti_string = 'L<sup>0</sup>T<sup>0</sup>'
    end

    mlti_string
  end
end
