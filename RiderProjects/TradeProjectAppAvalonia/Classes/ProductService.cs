using System;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json;
using Sieve.Models;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using TradeProjectAppAvalonia.Model;

namespace TradeProjectAppAvalonia.Classes
{
    public class ProductService
    {
        private readonly HttpClient _httpClient = new HttpClient();
        private readonly Messages _messages = new Messages();
        private const string ProductUrl = "https://localhost:44330/api/product";
        private const string ProductTypeUrl = "https://localhost:44330/api/Producttype";

        public ProductService()
        {

        }

        // Универсальный метод для отправки запросов и обработки ответов
        private async Task<T?> SendRequestAsync<T>(HttpMethod method, string url, object? data = null)
        {
            try
            {
                var request = new HttpRequestMessage(method, url);
                if (data != null)
                {
                    // Настройка сериализации с PreserveReferencesHandling
                    var settings = new JsonSerializerSettings
                    {
                        ReferenceLoopHandling = ReferenceLoopHandling.Ignore

                        //PreserveReferencesHandling = PreserveReferencesHandling.Objects, // Сохраняем ссылки на объекты
                        //Formatting = Formatting.Indented
                    };
                    var jsonData = JsonConvert.SerializeObject(data, settings);
                    request.Content = new StringContent(jsonData, Encoding.UTF8, "application/json");

                }

                var response = await _httpClient.SendAsync(request);
                var json = await response.Content.ReadAsStringAsync();

                if (!response.IsSuccessStatusCode)
                {
                    _messages.ShowError(json);
                    return default;
                }

                return JsonConvert.DeserializeObject<T>(json);
            }
            catch (HttpRequestException ex)
            {
                Console.WriteLine($"Ошибка при выполнении запроса: {ex.Message}");
                return default;
            }
            catch (Exception ex)
            {
                _messages.ShowError($"Неизвестная ошибка: {ex.Message}");
                return default;
            }
        }

        // Универсальный метод для получения списка
        public async Task<List<T>?> GetListAsync<T>(string baseUrl, SieveModel sieveModel)
        {
            var queryParams = $"?Filters={sieveModel.Filters}&Sorts={sieveModel.Sorts}&Page={sieveModel.Page}&PageSize={sieveModel.PageSize}";
            return await SendRequestAsync<List<T>>(HttpMethod.Get, $"{baseUrl}{queryParams}");
        }

        // Методы работы с продуктами
        public Task<List<Product>?> GetProducts(SieveModel sieveModel) =>
            GetListAsync<Product>(ProductUrl, sieveModel);

        public Task<Product?> GetProductByArticleAsync(string article) =>
            SendRequestAsync<Product>(HttpMethod.Get, $"{ProductUrl}/{article}");

        public Task<Product?>? CreateProductAsync(Product product) =>
            SendRequestAsync<ApiResponse>(HttpMethod.Post, ProductUrl, product)?.ContinueWith(t => t.Result?.Product);

        public Task<Product?> UpdateProductAsync(string article, Product product) =>
            article == product.ProductArticleNumber
                ? SendRequestAsync<Product>(HttpMethod.Put, $"{ProductUrl}/{article}", product)
                : throw new ArgumentException("Артикул продукта не совпадает.");

        public async Task<bool> DeleteProductAsync(string article)
        {
            var success = await SendRequestAsync<object>(HttpMethod.Delete, $"{ProductUrl}/{article}") != null;
            if (success)
            {
                // Удаление продукта из корзины
                var productInBasket = Session.Basket?.FirstOrDefault(bp => bp.Product?.ProductArticleNumber == article);
                if (productInBasket != null) productInBasket.Count = 0;

                Console.WriteLine("Продукт успешно удалён.");
            }
            return success;
        }

        // Методы работы с типами продуктов
        public Task<List<Producttype>?> GetProductTypesAsync(SieveModel sieveModel) =>
            GetListAsync<Producttype>(ProductTypeUrl, sieveModel);

        public Task<Producttype?> GetProductTypeByIdAsync(int id) =>
            SendRequestAsync<Producttype>(HttpMethod.Get, $"{ProductTypeUrl}/{id}");

        public Task<Producttype?>? CreateProductTypeAsync(Producttype productType) =>
            SendRequestAsync<ApiResponse>(HttpMethod.Post, ProductTypeUrl, productType)?.ContinueWith(t => t.Result?.Producttype);

        public Task<Producttype?>? UpdateProductTypeAsync(int id, Producttype productType) =>
            id == productType.ProductTypeId
                ? SendRequestAsync<Producttype>(HttpMethod.Put, $"{ProductTypeUrl}/{id}", productType)
                : throw new ArgumentException("ID продукта не совпадает.");

        public async Task<bool> DeleteProductTypeAsync(int id) =>
            await SendRequestAsync<object>(HttpMethod.Delete, $"{ProductTypeUrl}/{id}") != null;

    }
   

}

