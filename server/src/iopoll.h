////////////////////////////////////////////////////////////////////////
// OpenTibia - an opensource roleplaying game
////////////////////////////////////////////////////////////////////////
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////

#ifndef __IOPOLL__
#define __IOPOLL__
//#include "otsystem.h"

//#include "player.h"
#include "polls.h"

class IOPoll
{
	public:
		virtual ~IOPoll() {}
		static IOPoll* getInstance()
		{
			static IOPoll instance;
			return &instance;
		}
		
		bool loadPolls();
		bool getAccountVoted(uint32_t accountNumber, Poll* poll);
	    bool doComputePollVote(uint32_t pollId, uint32_t accountNumber, uint8_t pollVote);
	    bool doComputePollVote(uint32_t pollId, uint32_t accountNumber, std::string text);

	private:
		IOPoll() {}
};
#endif
