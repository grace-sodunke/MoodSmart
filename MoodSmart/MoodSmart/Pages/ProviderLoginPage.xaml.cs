using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace MoodSmart
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ProviderLoginPage : ContentPage
    {
        //providername is referred to from the renderer page  
        public string ProviderName
        {
            get;
            set;
        }
        public ProviderLoginPage(string _providername)
        {
            InitializeComponent();
            ProviderName = _providername;
        }
    }
}