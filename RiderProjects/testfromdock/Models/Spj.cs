using System;
using System.Collections.Generic;

namespace testfromdock.Models;

public partial class Spj
{
    public string SId { get; set; } = null!;

    public string PId { get; set; } = null!;

    public string JId { get; set; } = null!;

    public int Quantity { get; set; }

    public virtual J JIdNavigation { get; set; } = null!;

    public virtual P PIdNavigation { get; set; } = null!;

    public virtual S SIdNavigation { get; set; } = null!;
}
