using System.Collections.Generic;

namespace TradeProjectApp.Model;

public partial class Supplier
{
    public int SupplierId { get; set; }

    public string? Name { get; set; }

    public virtual ICollection<Product> Products { get; set; } = new List<Product>();
}
