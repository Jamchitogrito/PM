using System;
using System.Collections.Generic;
using System.Linq;
using TradeProjectAppAvalonia.Model;

namespace TradeProjectAppAvalonia.Classes
{
    public class Session
    {
        public static User? user = null;
        public static List<BasketProduct>? Basket = new List<BasketProduct>(); 
    }

    public class ApiResponse
    {
        public string? Message { get; set; }
        public Product? Product { get; set; }
        public Producttype? Producttype { get; set; }
        public Supplier? Supplier { get; set; }
        public Manufacturer? Manufacturer { get; set; }
        public Point? Point { get; set; }
        public Order? Order { get; set; }
        public Orderproduct? Orderproduct { get; set; }
        public User? User { get; set; }
        public  List<Product>? Products { get; set; }
        public  List<Producttype>? Producttypes { get; set; }
        public  List<Supplier>? Suppliers { get; set; }
        public List<Manufacturer>? Manufacturers { get; set; }
        public List<Point>? Points { get; set; }
        public List<Order>? Orders { get; set; }
        public List<Orderproduct>? Orderproducts { get; set; }
        public List<User>? Users { get; set; }

    }

    public class BasketProduct
    {

        public static event Action? BasketChanged;
        public Product? Product { get; set; }
        private int _count;

        public int Count
        {
            get => _count;
            set
            {
                _count = value;
                BasketChanged?.Invoke();
                if (_count == 0)
                {
                    RemoveProductFromBasket();
                }
            }
        }

        private void RemoveProductFromBasket()
        {
            var productToRemove = Session.Basket?.FirstOrDefault(bp => bp.Product == Product);
            if (productToRemove != null)
            {
                Session.Basket.Remove(productToRemove);
            }
        }

    }
}
