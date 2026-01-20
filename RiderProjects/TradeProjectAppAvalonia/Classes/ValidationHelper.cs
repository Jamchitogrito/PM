using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace TradeProjectAppAvalonia.Classes
{
    public class ValidationErrorResponse
    {
        public string Type { get; set; }
        public string Title { get; set; }
        public int Status { get; set; }
        public string TraceId { get; set; }
        public Dictionary<string, string[]> Errors { get; set; }
    }
    public class ValidationHelper
    {

        public static bool AreControlsValid(params object[] controls)
        {
            foreach (var control in controls)
            {
                if (control is TextBox textBox)
                {
                    // Проверяем, пустая ли строка в TextBox
                    if (string.IsNullOrWhiteSpace(textBox.Text))
                        return false;
                }
                else if (control is ComboBox comboBox)
                {
                    // Проверяем, пустой ли SelectedValue в ComboBox
                    if (comboBox.SelectedItem == null)
                        return false;
                }
                else
                {
                    throw new ArgumentException("Поддерживаются только TextBox и ComboBox.");
                }
            }

            return true;
        }
    }
}
