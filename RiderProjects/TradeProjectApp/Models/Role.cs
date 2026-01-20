using System.Collections.Generic;
using TradeProjectApp.Models;

namespace TradeProjectApp.Model;

public partial class Role
{
    public int RoleId { get; set; }

    public string Name { get; set; } = null!;

    public virtual ICollection<User> Users { get; set; } = new List<User>();
}
