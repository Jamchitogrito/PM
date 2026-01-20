using System.Windows;

namespace TradeProjectAppAvalonia.Classes
{
    public class UIHelper
    {
        /// <summary>
        /// Чередует Visbility.Collapsed и Visibility.Visible
        /// </summary>
        /// <param name="elements">Чередует Visbility.Collapsed и Visibility.Visible</param>
        public static void ToggleVisibility(params UIElement[] elements)
        {
            foreach (var element in elements)
            {
                if (element.Visibility == Visibility.Visible)
                {
                    element.Visibility = Visibility.Collapsed;
                }
                else
                {
                    element.Visibility = Visibility.Visible;
                }
            }
        }

        /// <summary>
        /// Меняет состояние Enabled на противоположное
        /// </summary>
        /// <param name="elements"></param>
        public static void ToggleEnabled(params UIElement[] elements)
        {
            foreach (var element in elements)
            {
                element.IsEnabled = !element.IsEnabled;
            }
        }
    }
}
