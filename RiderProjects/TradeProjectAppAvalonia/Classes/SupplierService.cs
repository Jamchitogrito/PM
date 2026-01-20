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
    public class SupplierService
    {
        private readonly HttpClient _httpClient = new HttpClient();
        private readonly Messages _messages = new Messages();
        private const string SupplierUrl = "https://localhost:44330/api/supplier";

        public SupplierService()
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
                    var settings = new JsonSerializerSettings
                    {
                        ReferenceLoopHandling = ReferenceLoopHandling.Ignore
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

        // Получение списка поставщиков с фильтрацией через Sieve
        public Task<List<Supplier>?> GetSuppliersAsync(SieveModel sieveModel) =>
            SendRequestAsync<List<Supplier>>(HttpMethod.Get, $"{SupplierUrl}?Filters={sieveModel.Filters}&Sorts={sieveModel.Sorts}&Page={sieveModel.Page}&PageSize={sieveModel.PageSize}");

        // Получение поставщика по ID
        public Task<Supplier?> GetSupplierByIdAsync(int id) =>
            SendRequestAsync<Supplier>(HttpMethod.Get, $"{SupplierUrl}/{id}");

        // Создание нового поставщика
        public Task<Supplier?>? CreateSupplierAsync(Supplier supplier) =>
            SendRequestAsync<ApiResponse>(HttpMethod.Post, SupplierUrl, supplier)?.ContinueWith(t => t.Result?.Supplier);

        // Обновление существующего поставщика
        public Task<Supplier?>? UpdateSupplierAsync(int id, Supplier supplier) =>
            id == supplier.SupplierId
                ? SendRequestAsync<Supplier>(HttpMethod.Put, $"{SupplierUrl}/{id}", supplier)
                : throw new ArgumentException("ID поставщика не совпадает.");

        // Удаление поставщика
        public async Task<bool> DeleteSupplierAsync(int id)
        {
            var success = await SendRequestAsync<object>(HttpMethod.Delete, $"{SupplierUrl}/{id}") != null;
            if (success)
            {
                Console.WriteLine("Поставщик успешно удалён.");
            }
            return success;
        }

       
    }
}
