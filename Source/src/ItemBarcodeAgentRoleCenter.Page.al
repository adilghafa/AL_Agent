//namespace Microsoft.Agent.ItemBarcodeAgent;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;
using System.Agents;
using System.Visualization;

page 70005 "Item Barcode Agent Role Center"
{
    ApplicationArea = All;
    Caption = 'Item with barcode';
    PageType = RoleCenter;
    Extensible = false;

    layout
    {
        area(RoleCenter)
        {
            part(Headline; "Headline RC Order Processor")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Embedding)
        {
            action(AgentTasks)
            {
                ApplicationArea = All;
                Caption = 'Agent Tasks';
                Image = Entries;
                RunObject = Page "Agent Tasks List";
                ToolTip = 'View the tasks completed or pending for this agent.';
            }
            action(Items)
            {
                ApplicationArea = All;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                ToolTip = 'View items and their barcode information.';
            }
        }
        area(Sections)
        {
            group(ItemCatalog)
            {
                Caption = 'Item catalog';

                action(ItemList)
                {
                    ApplicationArea = All;
                    Caption = 'Items';
                    RunObject = Page "Item List";
                    ToolTip = 'View and search items.';
                }
                action(ItemReferences)
                {
                    ApplicationArea = All;
                    Caption = 'Item references';
                    RunObject = Page "Item Reference List";
                    ToolTip = 'View item barcode and other reference entries.';
                }
            }
        }
    }
}
