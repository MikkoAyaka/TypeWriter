package me.gabber235.typewriter.citizens.entries.cinematic

import me.gabber235.typewriter.adapters.Colors
import me.gabber235.typewriter.adapters.Entry
import me.gabber235.typewriter.adapters.modifiers.EntryIdentifier
import me.gabber235.typewriter.adapters.modifiers.Help
import me.gabber235.typewriter.citizens.entries.entity.ReferenceNpcEntry
import me.gabber235.typewriter.entry.Criteria
import me.gabber235.typewriter.entry.Query
import me.gabber235.typewriter.entry.entries.CinematicAction
import me.gabber235.typewriter.utils.Icons
import org.bukkit.entity.Player

@Entry(
    "reference_npc_cinematic",
    "A reference to an existing npc specifically for cinematic",
    Colors.PINK,
    Icons.USER_TIE
)
/**
 * The `Reference NPC Cinematic` entry that plays a recorded animation back on a reference NPC.
 * When active, the original NPC will be hidden and a clone will be spawned in its place.
 *
 * ## How could this be used?
 *
 * This could be used to create a cinematic where the player is talking to an NPC.
 * Like going in to a store and talking to the shopkeeper.
 */
class ReferenceNpcCinematicEntry(
    override val id: String = "",
    override val name: String = "",
    override val criteria: List<Criteria> = emptyList(),
    override val recordedSegments: List<NpcRecordedSegment> = emptyList(),
    @Help("Reference npc to clone")
    @EntryIdentifier(ReferenceNpcEntry::class)
    val referenceNpc: String = "",
) : NpcCinematicEntry {
    override fun create(player: Player): CinematicAction {
        val referenceNpc =
            Query.findById<ReferenceNpcEntry>(this.referenceNpc) ?: throw Exception("Reference npc not found")

        return NpcCinematicAction(
            player,
            this,
            ReferenceNpcData(referenceNpc.npcId),
        )
    }
}
