using System;

namespace TradeProjectAppAvalonia.Model
{
    public partial class Product
    {
        public string? Image { get { return !String.IsNullOrWhiteSpace(Photo) ? $"/Resources/Images/{Photo}" : null; } }
        public string? ManufactureName
        {
            get
            {

                if (Manufacturer != null)
                {
                    return Manufacturer.Name;
                }
                else
                {
                    return "Не указано";
                }
            }
        }
        public string? ProductTypeName
        {
            get
            {

                if (ProductType != null)
                {
                    return ProductType.Name;
                }
                else
                {
                    return "Не указано";
                }
            }
        }
    }
}
