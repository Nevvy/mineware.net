local mineware_enable_menu = gui.Checkbox(gui.Reference("MISC", "GENERAL", "MAIN"), "lua_mineware_enable_menu", "MINEWARE.net", false)
local mineware_gui = gui.Window("lua_mineware_gui_pos", "MINEWARE.net BETA | 1.12", 200, 200, 200, 320)
local mineware_gui_groupbox = gui.Groupbox(mineware_gui, "SETTINGS", 10, 10, 180, 180)
local mineware_about = gui.Groupbox(mineware_gui, "About MINEWARE", 10, 200, 180, 80)
local mineware_about_text = gui.Text(mineware_about, "Author: Nevvy#0001")
local mineware_about_text2 = gui.Text(mineware_about, "Credits: zReko#1326")
local current_slot = 1
local tick_interval = globals.TickCount()
local get_weapon_slot = {}
local start_delay = false
local localPlayer = nil
local aw_wnd_ref = gui.Reference("MENU")
local old_hud_state = nil
local mineware_enable = {
    ["hotbar"] = gui.Checkbox(mineware_gui_groupbox, "lua_mineware_enable_hotbar", "Hotbar", false),
    ["health"] = gui.Checkbox(mineware_gui_groupbox, "lua_mineware_enable_health", "Health Bar", false),
    ["armor"] = gui.Checkbox(mineware_gui_groupbox, "lua_mineware_enable_armor", "Armor Bar", false),
    ["hud"] = gui.Checkbox(mineware_gui_groupbox, "lua_mineware_disable_hud", "Disable Default HUD", false),
    ["scale"] = gui.Slider(mineware_gui_groupbox, "lua_mineware_scale", "Scale", 100, 25, 300)
}
local decode = {
    ["hotbar"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/vIg33Fr.png"))),
    ["hp_100"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/iZsSAgH.png"))),
    ["hp_95"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/ar21geU.png"))),
    ["hp_90"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/a54z79G.png"))),
    ["hp_85"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/VaCRPap.png"))),
    ["hp_80"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/0R3UlqP.png"))),
    ["hp_75"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/ggTMSg5.png"))),
    ["hp_70"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/7xGr0TE.png"))),
    ["hp_65"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/XzFqfGt.png"))),
    ["hp_60"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/lMSAISA.png"))),
    ["hp_55"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/809kI4d.png"))),
    ["hp_50"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/2UO0Lwf.png"))),
    ["hp_45"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/2j5VI4X.png"))),
    ["hp_40"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/ugi8skL.png"))),
    ["hp_35"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/wwjMlyn.png"))),
    ["hp_30"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/MXi9NGq.png"))),
    ["hp_25"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/X2NkEKw.png"))),
    ["hp_20"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/xVuwcAb.png"))),
    ["hp_15"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/DVnFJgm.png"))),
    ["hp_10"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/WLND2rG.png"))),
    ["hp_5"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/gCXXKWc.png"))),
    ["hp_0"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/9r7Vj1M.png"))),
    ["armor_100"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/gzHGJKC.png"))),
    ["armor_95"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/xKliKl1.png"))),
    ["armor_90"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/zQrE2zJ.png"))),
    ["armor_85"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/KKpJkKP.png"))),
    ["armor_80"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/2K5jz4i.png"))),
    ["armor_75"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/fJHq13N.png"))),
    ["armor_70"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/pF5RPjy.png"))),
    ["armor_65"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/vqi586K.png"))),
    ["armor_60"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/SIxtdLw.png"))),
    ["armor_55"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/hJiNjtc.png"))),
    ["armor_50"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/GBcSA3b.png"))),
    ["armor_45"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/9reT6PD.png"))),
    ["armor_40"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/T78Sd51.png"))),
    ["armor_35"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/ZBPv8hh.png"))),
    ["armor_30"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/0TNTNMe.png"))),
    ["armor_25"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/Q0EywkM.png"))),
    ["armor_20"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/uVDkNTv.png"))),
    ["armor_15"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/yacvgJU.png"))),
    ["armor_10"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/Jk7y2Z4.png"))),
    ["armor_5"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/RCVpxrk.png"))),
    ["armor_0"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/ybzii6k.png"))),
    ["slot"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/IOglVsh.png"))),
    ["w_usp silencer"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/ljm95bT.png"))),
    ["w_ssg08"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/CG8EvuY.png"))),
    ["w_mp7"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/xjEbexD.png"))),
    ["w_hkp2000"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/ObFHnFe.png"))),
    ["w_nova"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/Aqfb3AB.png"))),
    ["w_p250"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/ja5uTCX.png"))),
    ["w_cz75a"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/L3jafED.png"))),
    ["w_m249"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/Z849Zy5.png"))),
    ["w_revolver"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/S2MjmxD.png"))),
    ["w_negev"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/uTy9kzK.png"))),
    ["w_aug"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/nFuhsUw.png"))),
    ["w_g3sg1"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/nKwyUWr.png"))),
    ["w_mp5sd"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/sLGLeaa.png"))),
    ["w_ump45"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/WAnwiG3.png"))),
    ["w_ak47"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/6doraqS.png"))),
    ["w_bizon"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/5MRvVao.png"))),
    ["w_galilar"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/dqETtqG.png"))),
    ["w_sg556"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/CafTXA8.png"))),
    ["w_elite"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/Xxuioex.png"))),
    ["w_scar20"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/DJCP5nS.png"))),
    ["w_famas"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/tZMSa5T.png"))),
    ["w_xm1014"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/uRIcfp4.png"))),
    ["w_fiveseven"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/PSSesXt.png"))),
    ["w_glock"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/xNkfnjk.png"))),
    ["w_deagle"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/96hP2Z3.png"))),
    ["w_mac10"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/l58spNS.png"))),
    ["w_knife"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/FaUXB7R.png"))),
    ["w_tec9"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/3hGEhpQ.png"))),
    ["w_m4a1"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/AAqNp7C.png"))),
    ["w_mag7"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/gJwkQrZ.png"))),
    ["w_taser"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/ZJVLaV4.png"))),
    ["w_p90"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/JRNf3H7.png"))),
    ["w_mp9"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/rxhi5NH.png"))),
    ["w_awp"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/2cKLRTy.png"))),
    ["w_sawedoff"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/35CA1R8.png"))),
    ["w_knife t"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/YjDLdEF.png"))),
    ["w_fists"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/mVKiivC.png"))),
    ["w_knife m9 bayonet"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/mWr2F5w.png"))),
    ["w_knife karambit"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/ix5dLYU.png"))),
    ["w_knife falchion"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/Ks5av9h.png"))),
    ["w_knife flip"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/hE0Bnxs.png"))),
    ["w_knife ursus"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/mz9kN2d.png"))),
    ["w_knife gypsy jackknife"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/99QmwLX.png"))),
    ["w_knife css"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/lY6PO2r.png"))),
    ["w_bayonet"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/OMzfPb7.png"))),
    ["w_knife tactical"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/ixJULFS.png"))),
    ["w_knife butterfly"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/KpbNBHz.png"))),
    ["w_hammer"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/kgsiAVI.png"))),
    ["w_axe"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/c8yGRDz.png"))),
    ["w_spanner"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/aJ8QPDW.png"))),
    ["w_knife survival bowie"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/vCO5cSy.png"))),
    ["w_knife stiletto"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/fvN20CX.png"))),
    ["w_knife gut"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/c5PhyH3.png"))),
    ["w_knife push"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/t1ERZSK.png"))),
    ["w_knife widowmaker"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/ip8a2yf.png"))),
    ["w_m4a1 silencer"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/4zrkB1k.png"))),
    ["w_hegrenade"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/GzLR0Eu.png"))),
    ["w_smokegrenade"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/cRYOId3.png"))),
    ["w_flashbang"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/m9JaDkc.png"))),
    ["w_molotov"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/Xv7Mk2Q.png"))),
    ["w_incgrenade"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/GjXyiHf.png"))),
    ["w_decoy"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/koyF2VN.png"))),
    ["w_c4"] = draw.CreateTexture(common.DecodePNG(http.Get("https://i.imgur.com/IDPbISq.png")))
}

local size = {
    ["hotbar_h"] = 66,
    ["hotbar_w"] = 546,
    ["hotbarslot_h"] = 72,
    ["hotbarslot_w"] = 552,
    ["ibar_h"] = 27,
    ["ibar_w"] = 243,
    ["slot_hw"] = 72,
    ["slot_icn"] = 48,
    ["slotmove"] = 60
}
local weapon_table = {
    {
        "m4a1",
        "m4a1 silencer",
        "ak47",
        "aug",
        "awp",
        "famas",
        "g3sg1",
        "galilar",
        "scar20",
        "sg556",
        "ssg08",
        "bizon",
        "mac10",
        "mp7",
        "mp9",
        "p90",
        "ump45",
        "mp5sd",
        "m249",
        "mag7",
        "negev",
        "nova",
        "sawedoff",
        "xm1014"
    },
    {
        "usp silencer",
        "deagle",
        "elite",
        "fiveseven",
        "glock",
        "hkp2000",
        "p250",
        "tec9",
        "cz75a",
        "revolver"
    },
    {
        "knife",
        "knife t",
        "bayonet",
        "knife flip",
        "knife gut",
        "knife css",
        "knife karambit",
        "knife m9 bayonet",
        "knife tactical",
        "knife falchion",
        "knife survival bowie",
        "knife butterfly",
        "knife push",
        "knife ursus",
        "knife gypsy jackknife",
        "knife stiletto",
        "knife widowmaker",
        "axe",
        "spanner",
        "hammer",
        "fists",
        "taser"
    },
    {
        "hegrenade",
        "smokegrenade",
        "flashbang",
        "molotov",
        "incgrenade",
        "decoy"
    },
    {
        "c4"
    }
}
local count = 0
local function get_wep()
    if globals.TickCount() - tick_interval >= 0 and start_delay == true then
        get_weapon_slot = {}
        count = 0
        for i = 0, 8, 1 do
            for ii, v in pairs(weapon_table) do
                for iii, vv in pairs(v) do
                    if localPlayer:GetPropEntity("m_hMyWeapons", "00" .. i) ~= nil and localPlayer:GetPropEntity("m_hMyWeapons", "00" .. i):GetName() == vv then
                        if ii == 4 then
                            count = count + 1
                        end
                        local info = {vv, ii, count}
                        table.insert(get_weapon_slot, info)
                    end
                end
            end
        end
        for ii, v in pairs(weapon_table) do
            for _, vv in pairs(v) do
                local active_wpn_ent = localPlayer:GetPropEntity("m_hActiveWeapon")
                if active_wpn_ent ~= nil and active_wpn_ent:GetName() == vv then
                    current_slot = ii
                end
            end
        end
        start_delay = false
    end
end
local function get_stuff()
    start_delay = true
    tick_interval = globals.TickCount()
end
local function slot_manager(Event)
    if (Event:GetName() == "item_equip" or Event:GetName() == "item_pickup") then
        get_stuff()
    end
end
local function window_manage()
    if mineware_enable_menu:GetValue(1) then
        mineware_gui:SetActive(1)
    else
        mineware_gui:SetActive(0)
    end

    if mineware_enable_menu:GetValue(1) then
        mineware_gui:SetActive(aw_wnd_ref:IsActive())
    end
end
local function mineware()
    window_manage()
    if entities.GetLocalPlayer() == nil then
        return
    end
    localPlayer = entities.GetLocalPlayer()
    if not localPlayer:IsAlive() then
        return
    end
    local w, h = draw.GetScreenSize()
    local hud_scale = mineware_enable.scale:GetValue() / 100
    local mc_hud = mineware_enable.hud:GetValue()
    local mc_hud_hotbar = mineware_enable.hotbar:GetValue()
    local mc_hud_health = mineware_enable.health:GetValue()
    local mc_hud_armor = mineware_enable.armor:GetValue()
    if mc_hud_hotbar then
        local x = w / 2 - (size.hotbar_w * hud_scale) / 2
        local y = h - (size.hotbar_h * hud_scale) * 1.04
        draw.SetTexture(decode.hotbar)
        draw.FilledRect(x, y, x + (size.hotbar_w * hud_scale), y + (size.hotbar_h * hud_scale))
    end

    if mc_hud_health then
        local calc_health = math.floor(localPlayer:GetHealth() / 5) * 5
        local x = w / 2 - (size.hotbar_w * hud_scale) / 2
        local y = h - (size.hotbar_h * hud_scale) * 1.55
        draw.SetTexture(decode["hp_" .. calc_health])
        draw.FilledRect(x, y, x + (size.ibar_w * hud_scale), y + (size.ibar_h * hud_scale))
    end

    if mc_hud_armor then
        local calc_armor = math.floor(localPlayer:GetProp("m_ArmorValue") / 5) * 5
        local x = w / 2 + (size.hotbar_w * hud_scale) / 2 - (size.ibar_w * hud_scale)
        local y = h - (size.hotbar_h * hud_scale) * 1.55
        draw.SetTexture(decode["armor_" .. calc_armor])
        draw.FilledRect(x, y, x + (size.ibar_w * hud_scale), y + (size.ibar_h * hud_scale))
    end

    if mc_hud_hotbar then
        local count_same = 0
        local x = w / 2 - (size.hotbarslot_w * hud_scale) / 2 + (size.slotmove * hud_scale) * (current_slot - 1)
        local y = h - (size.hotbarslot_h * hud_scale)
        draw.SetTexture(decode.slot)
        draw.FilledRect(x, y, x + (size.slot_hw * hud_scale), y + (size.slot_hw * hud_scale))
        for i, v in pairs(get_weapon_slot) do
            if v[2] == 4 then
                count_same = count_same + 1
            end
            local x = w / 2 - (size.hotbarslot_w * hud_scale) / 2 + (size.slotmove * hud_scale) * (v[2] - 1)
            local y = h - (size.hotbarslot_h * hud_scale)
            --draw.TextShadow(255,255+(10*i),v[1])
            if decode["w_" .. v[1]] ~= nil then
                draw.SetTexture(decode["w_" .. v[1]])
                local x_left = x + 12 * hud_scale
                local y_top = y + 12 * hud_scale
                local x_right = x + 60 * hud_scale
                local y_bottom = y + 60 * hud_scale
                if count > 1 then
                    if count_same == 1 and v[2] == 4 then
                        x_left = x + 12 * hud_scale
                        y_top = y + 12 * hud_scale
                        x_right = x + 36 * hud_scale
                        y_bottom = y + 36 * hud_scale
                    elseif count_same == 2 and v[2] == 4 then
                        x_left = x + 36 * hud_scale
                        y_top = y + 12 * hud_scale
                        x_right = x + 60 * hud_scale
                        y_bottom = y + 36 * hud_scale
                    elseif count_same == 3 and v[2] == 4 then
                        x_left = x + 12 * hud_scale
                        y_top = y + 35 * hud_scale
                        x_right = x + 36 * hud_scale
                        y_bottom = y + 60 * hud_scale
                    elseif count_same == 4 and v[2] == 4 then
                        x_left = x + 36 * hud_scale
                        y_top = y + 36 * hud_scale
                        x_right = x + 60 * hud_scale
                        y_bottom = y + 60 * hud_scale
                    end
                end
                if v[1] == "taser" then
                    x_left = x + 36 * hud_scale
                    y_top = y + 36 * hud_scale
                    x_right = x + 60 * hud_scale
                    y_bottom = y + 60 * hud_scale
                end
                draw.Color(255,255,255,255)
                draw.FilledRect(x_left, y_top, x_right, y_bottom)
            end
        end
    end
    get_wep()
    if mc_hud and mc_hud ~= old_hud_state then
        client.SetConVar("hidehud", 8, true)
    elseif not mc_hud and mc_hud ~= old_hud_state then
        client.SetConVar("hidehud", 0, true)
    end
    old_hud_state = mc_hud
end
get_stuff()
client.AllowListener("item_equip")
client.AllowListener("item_pickup")
callbacks.Register("FireGameEvent", "slot_manager", slot_manager)
callbacks.Register("Draw", "lua_mineware", mineware)