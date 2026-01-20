using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using Sieve.Models;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using TradeProjectAppAvalonia.Model;

namespace TradeProjectAppAvalonia.Classes
{
    public class OrderService
    {
        private readonly HttpClient _httpClient = new HttpClient();
        private readonly Messages _messages = new Messages();
        private const string orderProductUrl = "https://localhost:44330/api/orderproduct";
        private const string orderUrl = "https://localhost:44330/api/order";

        // Получение списка товаров в заказе с фильтрацией через Sieve
        public Task<List<Orderproduct>?> GetOrderProductsAsync(SieveModel sieveModel) =>
            SendRequestAsync<List<Orderproduct>>(HttpMethod.Get, $"{orderProductUrl}?Filters={sieveModel.Filters}&Sorts={sieveModel.Sorts}&Page={sieveModel.Page}&PageSize={sieveModel.PageSize}");

        // Получение товаров в заказе по ID
        public Task<List<Orderproduct>?> GetProductsInOrderAsync(int orderId) =>
            SendRequestAsync<List<Orderproduct>>(HttpMethod.Get, $"{orderProductUrl}/order/{orderId}");

        // Добавление товара в заказ
        public Task<Orderproduct?> AddProductToOrderAsync(Orderproduct orderproduct) =>
            SendRequestAsync<ApiResponse>(HttpMethod.Post, $"{orderProductUrl}", orderproduct)
            .ContinueWith(t=> t.Result?.Orderproduct);

        // Обновление товара в заказе
        public Task<Orderproduct?> UpdateProductInOrderAsync(int orderId, string productArticleNumber, int newCount) =>
            SendRequestAsync<Orderproduct>(HttpMethod.Put, $"{orderProductUrl}/order/{orderId}/product/{productArticleNumber}", new { newCount });

        // Удаление товара из заказа
        public async Task<bool> RemoveProductFromOrderAsync(int orderId, string productArticleNumber)
        {
            var success = await  SendRequestAsync<object>(HttpMethod.Delete, $"{orderProductUrl}/order/{orderId}/product/{productArticleNumber}") != null;
            if(success)
            {
                Console.WriteLine($"Продукт с артикулом {productArticleNumber} успешно удалён из корзины.");
            }
            return success;
        }


        // Получение заказов
        public Task<List<Order>?> GetOrdersAsync(SieveModel sieveModel) =>
            SendRequestAsync<List<Order>>(HttpMethod.Get,
                $"{orderUrl}?Filters={sieveModel.Filters}&Sorts={sieveModel.Sorts}&Page={sieveModel.Page}&PageSize={sieveModel.PageSize}");

        // Добавление заказа
        public Task<Order?> CreateOrderAsync(Order order) =>
            SendRequestAsync<ApiResponse>(HttpMethod.Post, $"{orderUrl}", order)
                .ContinueWith(t => t.Result?.Order);

        // Изменение заказа
        public Task<Order?> UpdateOrderAsync(int orderId, Order order) =>
            SendRequestAsync<Order>(HttpMethod.Put, $"{orderUrl}/{orderId}", order);

        // Удаление заказа
        public async Task<bool> RemoveOrderAsync(int orderId)
        {
            var success = await SendRequestAsync<object>(HttpMethod.Delete, $"{orderUrl}/{orderId}") != null;
            if (success)
            {
                Console.WriteLine($"Заказ с id {orderId} успешно удалён");
            }
            return success;
        }
        // Универсальный метод для отправки запросов и обработки ответов
        private async Task<T?> SendRequestAsync<T>(HttpMethod method, string url, object? data = null)
        {
            try
            {
                var request = new HttpRequestMessage(method, url);
                if (data != null)
                {
                    var jsonData = JsonConvert.SerializeObject(data, new JsonSerializerSettings
                    {
                        ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                    });
                    request.Content = new StringContent(jsonData, System.Text.Encoding.UTF8, "application/json");
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
                _messages.ShowError($"Ошибка при выполнении запроса: {ex.Message}");
                return default;
            }
            catch (Exception ex)
            {
                _messages.ShowError($"Неизвестная ошибка: {ex.Message}");
                return default;
            }
        }
        

    }
}
