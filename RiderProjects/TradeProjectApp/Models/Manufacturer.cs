using System.Collections.Generic;
using TradeProjectApp.Model;

namespace TradeProjectApp.Models;

public partial class Manufacturer
{
    public int ManufacturerId { get; set; }

    public string? Name { get; set; }

    public virtual ICollection<Product> Products { get; set; } = new List<Product>();
}
